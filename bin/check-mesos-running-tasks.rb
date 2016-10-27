#! /usr/bin/env ruby
#
#   check-mesos-tasks
#
# DESCRIPTION:
#   This plugin checks that there are running tasks on a mesos cluster
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

# Mesos master default ports
MASTER_DEFAULT_PORT = '5050'.freeze

class MesosNodeStatus < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Mesos server',
         short: '-s SERVER',
         long: '--server SERVER',
         default: 'localhost'

  option :port,
         description: "port (default #{MASTER_DEFAULT_PORT})",
         short: '-p PORT',
         long: '--port PORT',
         required: false

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  option :mode,
         description: 'eq lt gt or rg',
         short: '-m MODE',
         long: '--mode MODE',
         required: true

  option :min,
         description: 'min value on range',
         short: '-l VALUE',
         long: '--low VALUE',
         required: false,
         derfault: 0


  option :max,
         description: 'max value on range',
         short: '-h VALUE',
         long: '--high VALUE',
         required: false,
         default: 1

  option :value,
         description: 'value to check against',
         short: '-v VALUE',
         long: '--value VALUE',
         default: 0,
         required: false


  def run

    port = config[:port] || MASTER_DEFAULT_PORT
    uri = '/metrics/snapshot'
    mode = config[:mode]
    value = config[:value].to_i
    server = config[:server]

    begin
      server = get_leader_url server, port
      r = RestClient::Resource.new("#{server}#{uri}", timeout: config[:timeout]).get
      metrics = JSON.parse(r)
      metric_value = metrics['master/tasks_running'].round
      critical 'master/tasks_running property not found! ' if metric_value.nil?

      case mode
        when 'eq'
          critical "The number of running tasks cluster is equal to #{value}!" if metric_value.equal? value
        when 'lt'
          critical "The number of running tasks cluster is lower than #{value}!" if metric_value < value
        when 'gt'
          critical "The number of running tasks cluster is greater than #{value}!" if metric_value > value
        when 'rg'
          min = config[:min]
          max = config[:max]

          unless (min.to_i..max.to_i).include? metric_value
            critical "The number of running tasks in cluster is not in #{min} - #{max} value range!"
          end
      end

    end
    ok
  end

  #Checks if a value is numeric
  def numeric?(stringValue)
    Float(stringValue) != nil rescue false
  end

  def get_leader_url(server, port)
    RestClient::Resource.new("http://#{server}:#{port}/redirect").get.request.url
  end

  private :numeric?
  private :get_leader_url
end
