require_relative './spec_helper.rb'
require_relative '../bin/check-mesos-lost-tasks.rb'
require_relative './fixtures.rb'

require 'sensu-plugin/check/cli'

# rubocop:disable Style/ClassVars
class MesosLostTasksCheck
  at_exit do
    @@autorun = false
  end

  def critical(*)
    ;
  end

  def warning(*)
    ;
  end

  def ok(*)
    ;
  end

  def unknown(*)
    ;
  end
end

def check_results(parameters)
  check = MesosLostTasksCheck.new parameters.split(' ')
  check.check_tasks(mesos_metrics_response, parameters.split(' ').at(3).to_i)
end

describe 'MesosLostTasksCheck' do
  describe '#run' do
    it 'tests that a lost tasks metrics are ok' do
      expect(check_results '--server localhost --value 42').to be 'CheckMesosLostTasks OK'
    end

    it 'tests that a lost tasks metrics are ko' do
      expect(check_results '--server localhost --value 0').to be critical('The number of LOST tasks [42] is bigger than provided [0]!')
    end
  end
end