require 'sensu-plugin/metric/cli'
require 'rest-client'
require 'socket'
require 'json'

class MarathonInstancesMetrics < Sensu::Plugin::Metric::CLI::Graphite
  INSTANCE_METRICS = "instances","tasksStaged","tasksRunning","tasksHealthy","tasksUnhealthy"
  INSTANCES = "instances"
  RUNNING = "taskRunning"
  INSTANCES_RUNNING_PERC ="instancesRunningPerc"
  option :scheme,
         description: 'Metric naming scheme',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.marathon"

  option :server,
         description: 'Marathon Host',
         short: '-h SERVER',
         long: '--host SERVER',
         default: 'localhost2'

  option :port,
         description: 'Marathon port',
         short: '-p PORT',
         long: '--port PORT',
         required: false,
         default: '8080'

  option :metrics,
         description: 'Metrics wanted to measure from apps',
         short: '-m METRICS',
         long: '--metrics METRICS',
         required: false

  option :timeout,
         description: 'timeout in seconds',
         short: '-t TIMEOUT',
         long: '--timeout TIMEOUT',
         proc: proc(&:to_i),
         default: 5

  def run

    response = RestClient::Resource.new("#{config[:server]}:#{config[:port]}/v2/apps/", timeout: config[:timeout]).get
    all_apps = JSON.parse(response)['apps']
    unless config[:metrics].nil?
      config[:metrics].split(',').each do |input_metric|
        INSTANCE_METRICS.push(input_metric)
      end
      INSTANCE_METRICS.uniq!
    end

    all_apps.each do |app|
      INSTANCE_METRICS.each do |metric_name|
        output([config[:scheme],app["id"][1..-1].gsub('/','.'),metric_name].join('.'), app[metric_name])
      end
    end
    ok
  rescue Errno::ECONNREFUSED
    critical 'Marathon is not responding'
  rescue RestClient::RequestTimeout
    critical 'Marathon Connection timed out'
  end
end
