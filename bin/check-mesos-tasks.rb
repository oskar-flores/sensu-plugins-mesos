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
         description: 'Mesos servers',
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

  def run

    port = config[:port] || MASTER_DEFAULT_PORT
    uri = '/metrics/snapshot'

    begin
      r = RestClient::Resource.new("http://#{config[:server]}:#{port}#{uri}", timeout: config[:timeout]).get
      metrics = JSON.parse(r)
      critical 'master/tasks_running property not found! ' if metrics['master/tasks_running'].nil?
      critical 'The number of running tasks on cluster is 0!' if metrics['master/tasks_running'].equal? 0.0
    end
    ok
  end
end
