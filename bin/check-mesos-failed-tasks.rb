#! /usr/bin/env ruby
#
#   check-mesos-failed-tasks
#
# DESCRIPTION:
#   This plugin checks that there are less or same number of failed tasks than provided on a Mesos cluster
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
MASTER_DEFAULT_PORT ||= '5050'.freeze

class MesosFailedTasksCheck < Sensu::Plugin::Check::CLI
  check_name 'CheckMesosFailedTasks'
  @metrics_name = 'master/tasks_failed'.freeze

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

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  option :value,
         description: 'value to check against',
         short: '-v VALUE',
         long: '--value VALUE',
         default: 0,
         required: false

  def run
    if config[:value].to_i < 0
      unknown 'Number of failed tasks cannot be negative'
    end

    server = config[:server]
    port = config[:port] || MASTER_DEFAULT_PORT
    uri = '/metrics/snapshot'
    timeout = config[:timeout].to_i
    value = config[:value].to_i

    begin
      server = get_leader_url server, port
      # remove comment for debugging purpose
      # puts(server)

      r = RestClient::Resource.new("#{server}#{uri}", timeout).get
      tasks_failed = check_tasks(r)

      if tasks_failed > value
        critical "The number of FAILED tasks [#{tasks_failed}] is bigger than provided [#{value}]!"
      end
    end
    ok
  end

  def get_leader_url(server, port)
    RestClient::Resource.new("http://#{server}:#{port}/redirect").get.request.url
  end

  # Parses JSON data as returned from Mesos's metrics API
  # @param data [String] Server response
  # @return tasks_failed [Integer] Number of failed tasks in Mesos
  def check_tasks(data)
    begin
      tasks_failed = JSON.parse(data)[MesosFailedTasksCheck.metrics_name]
    rescue JSON::ParserError
      raise "Could not parse JSON response: #{data}"
    end

    if tasks_failed.nil?
      raise "No metrics for [#{MesosFailedTasksCheck.metrics_name}] in server response: #{data}"
    end

    tasks_failed.round.to_i
  end
end
