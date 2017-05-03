#! /usr/bin/env ruby
#
#   check-mesos-gpu-balance
#
# DESCRIPTION:
#   This plugin checks that there is less GPU imbalance than specified on a certain mesos cluster
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
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'json'

# Mesos master default ports
MASTER_DEFAULT_PORT ||= '5050'.freeze

class MesosGpuBalanceCheck < Sensu::Plugin::Check::CLI
  check_name 'MesosGpuBalanceCheck'
  @metrics_name = 'slaves'.freeze
  CHECK_TYPE = 'gpus'.freeze

  class << self
    attr_reader :metrics_name
  end

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

  option :uri,
         description: 'Endpoint URI',
         short: '-u URI',
         long: '--uri URI',
         default: '/master/slaves'

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  option :crit,
         description: 'Critical value to check against',
         short: '-c VALUE',
         long: '--critical VALUE',
         proc: proc(&:to_i),
         default: 0,
         required: false

  option :warn_th,
         description: 'Warning value to check against',
         short: '-w VALUE',
         long: '--warning VALUE',
         proc: proc(&:to_i),
         default: 0,
         required: false

  def run
    if config[:crit].to_i < 0 || config[:warn_th].to_i < 0
      unknown 'Thresholds cannot be negative'
    end

    server = config[:server]
    port = config[:port] || MASTER_DEFAULT_PORT
    uri = config[:uri]
    timeout = config[:timeout].to_i
    crit = config[:crit].to_i
    warn_th = config[:warn_th].to_i

    begin
      server = get_leader_url server, port
      r = RestClient::Resource.new("#{server}#{uri}", timeout).get
    rescue Errno::ECONNREFUSED, RestClient::ResourceNotFound, SocketError
      critical  "Mesos #{server} is not responding"
    rescue RestClient::RequestTimeout
      critical  "Mesos #{server} connection timed out"
      compare = get_check_diff(get_slaves(r))
      if compare['diff'] > crit
        critical "There is a GPU usage diff of #{compare['diff']} bigger than #{crit} " + compare['msg']
      end
      if compare['diff'] > warn_th
        warning "There is a GPU usage diff of #{compare['diff']} bigger than #{warn_th} " + compare['msg']
      end
    end
    ok
  end

  # Redirects server call to discover the Leader
  # @param server [String] Server address
  # @param port [Number] api port
  # @return [Url] Url representing the Leader

  def get_leader_url(server, port)
    RestClient::Resource.new("http://#{server}:#{port}/redirect").get.request.url
  end

  # Parses JSON data as returned from Mesos's metrics API
  # @param data [String] Server response
  # @return tasks_failed [Integer] Number of failed tasks in Mesos
  def get_slaves(data)
    begin
      slaves = JSON.parse(data)[MesosGpuBalanceCheck.metrics_name]
    rescue JSON::ParserError
      raise "Could not parse JSON response: #{data}"
    end

    if slaves.nil?
      raise "No metrics for [#{MesosGpuBalanceCheck.metrics_name}] in server response: #{data}"
    end

    slaves
  end

  def get_check_diff(slavelist)
    begin
      usages = {}
      check_diff = {}
      slavelist.each do |slaveinfo|
        usages.store(slaveinfo['hostname'], slaveinfo['used_resources'][CHECK_TYPE] * 100 / slaveinfo['resources'][CHECK_TYPE])
      end
      sorted = usages.sort_by { |_hostname, total| total }
      max = usages.length - 1
      check_diff['diff'] = sorted[max][1] - sorted[0][1]
      check_diff['msg'] = "Hostname #{sorted[0][0]} uses #{sorted[0][1]}% and Hostname #{sorted[max][0]} uses #{sorted[max][1]}%"
    end
    check_diff
  end
end
