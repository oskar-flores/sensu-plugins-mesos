#! /usr/bin/env ruby
#
#   check-mesos
#
# DESCRIPTION:
#   This plugin checks that the health url returns 200 OK
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
#   Copyright 2015, Tom Stockton (tom@stocktons.org.uk)
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'

# Mesos default ports are defined here: http://mesos.apache.org/documentation/latest/configuration
MASTER_DEFAULT_PORT ||= '5050'.freeze
SLAVE_DEFAULT_PORT ||= '5051'.freeze

class MesosNodeStatus < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Mesos servers, comma separated',
         short: '-s SERVER1,SERVER2,...',
         long: '--server SERVER1,SERVER2,...',
         default: 'localhost'

  option :mode,
         description: 'master or slave',
         short: '-m MODE',
         long: '--mode MODE',
         required: true

  option :port,
         description: "port (default #{MASTER_DEFAULT_PORT} for master, #{SLAVE_DEFAULT_PORT} for slave)",
         short: '-p PORT',
         long: '--port PORT',
         required: false

  option :uri,
         description: 'Endpoint URI',
         short: '-u URI',
         long: '--uri URI',
         default: '/health'

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  def run
    mode = config[:mode]
    servers = config[:server]
    uri = config[:uri]
    case mode
    when 'master'
      port = config[:port] || MASTER_DEFAULT_PORT
    when 'slave'
      port = config[:port] || SLAVE_DEFAULT_PORT
    end
    failures = []
    servers.split(',').each do |server|
      begin
        r = RestClient::Resource.new("http://#{server}:#{port}#{uri}", timeout: config[:timeout]).get
        if r.code != 200
          failures << "#{mode} on #{server} is not responding"
        end
      rescue Errno::ECONNREFUSED, RestClient::ResourceNotFound, SocketError
        failures << "Mesos #{mode} on #{server} is not responding"
      rescue RestClient::RequestTimeout
        failures << "Mesos #{mode} on #{server} connection timed out"
      end
    end
    if failures.empty?
      ok "Mesos #{mode} is running on #{servers}"
    else
      critical failures.join("\n")
    end
  end
end
