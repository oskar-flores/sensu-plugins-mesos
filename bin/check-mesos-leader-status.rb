#! /usr/bin/env ruby
#
#   check-mesos-leader-status
#
# DESCRIPTION:
#   This plugin checks that the health url of the leader master returns 200 OK
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

# Mesos default ports are defined here: http://mesos.apache.org/documentation/latest/configuration
MASTER_DEFAULT_PORT ||= '5050'.freeze

class MesosLeaderNodeStatus < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Mesos server',
         short: '-s SERVER',
         long: '--server SERVER',
         default: 'localhost'

  option :port,
         description: "port (default #{MASTER_DEFAULT_PORT} for master)",
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
    server = config[:server]
    port = config[:port] || MASTER_DEFAULT_PORT
    uri = '/master/redirect'
    begin
      r = RestClient::Resource.new("http://#{server}:#{port}#{uri}", timeout: config[:timeout]).get
      if r.code == 503
        critical "#{config[:mode]} on #{server} is not responding"
      end
    rescue Errno::ECONNREFUSED, RestClient::ResourceNotFound, SocketError
      critical "Mesos #{mode} on #{server} is not responding"
    rescue RestClient::RequestTimeout
      critical "Mesos #{mode} on #{server} connection timed out"
    end
    ok
  end
end
