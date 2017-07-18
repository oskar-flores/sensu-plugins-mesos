#! /usr/bin/env ruby
#
#   check-marathon-healthy-app
#
# DESCRIPTION:
#   This plugin checks the number of healthy instances for the provided application id
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: rest-client
#   gem: json
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright 2016, Oskar Flores (oskar.flores@gmail.com)
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

# Marathon master default port
MASTER_DEFAULT_PORT = '8080'.freeze

class MarathonHealthyAppCheck < Sensu::Plugin::Check::CLI
  check_name 'CheckMarathonHealthyApp'

  option :server,
         description: 'Marathon server',
         short: '-s SERVER',
         long: '--server SERVER',
         required: false,
         default: 'localhost'

  option :port,
         description: "port (default #{MASTER_DEFAULT_PORT})",
         short: '-p PORT',
         long: '--port PORT',
         required: false,
         default: MASTER_DEFAULT_PORT

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         required: false,
         default: 5

  option :application,
         description: 'Marathon application identifier',
         short: '-a VALUE',
         long: '--application VALUE',
         required: true

  option :warning,
         description: 'value to raise a WARNING alarm',
         short: '-w VALUE',
         long: '--warning VALUE',
         required: true

  option :critical,
         description: 'value to raise a CRITICAL alarm',
         short: '-c VALUE',
         long: '--critical VALUE',
         required: true

  def run
    server = config[:server]
    port = config[:port]
    timeout = config[:timeout]
    application = config[:application]
    uri = '/v2/apps/' + application
    warning = config[:warning].to_f
    critical = config[:critical].to_f

    begin
      data = RestClient::Resource.new("#{server}:#{port}#{uri}", timeout: timeout).get
      healthy_instances_ratio = get_healthy_instances_ratio data
      check_marathon_healthy_app(healthy_instances_ratio, warning, critical)
    rescue Errno::ECONNREFUSED, RestClient::ResourceNotFound, SocketError
      critical "Marathon #{server} is not responding"
    rescue RestClient::RequestTimeout
      critical "Marathon #{server} connection timed out"
    end
    ok
  end

  # Parses JSON data as returned from Marathon API
  # @param data [String] Server response
  # @return [Numeric] Ratio of healthy instances to deployed instances

  def get_healthy_instances_ratio(data)
    begin
      instances = JSON.parse(data)['app']['instances']
      healthy = JSON.parse(data)['app']['tasksHealthy']
    rescue JSON::ParserError
      raise "Could not parse JSON response: #{data}"
    end

    if instances.nil?
      raise "No 'instances' in server response: #{data}"
    end

    if healthy.nil?
      raise "No 'tasksHealthy' in server response: #{data}"
    end

    (healthy.to_f / instances.to_f)
  end

  def check_marathon_healthy_app(metric_value, warning, critical)

    critical "The number of healthy instances is less than #{critical * 100}%!" if metric_value <= critical

    warning "The number of healthy instances is less than #{warning * 100}%!" if metric_value <= warning

  end

  public :get_healthy_instances_ratio

  public :check_marathon_healthy_app

end
