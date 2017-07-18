require_relative './spec_helper.rb'
require_relative '../bin/check-mesos-lost-tasks.rb'
require_relative './fixtures.rb'

require 'sensu-plugin/check/cli'

# rubocop:disable Style/ClassVars
class MesosLostTasksCheck
  at_exit do
    @@autorun = false
  end
end

describe 'MesosLostTasksCheck' do
  def check_lost(parameters)

    check = MesosLostTasksCheck.new parameters.split(' ')
    check.check_tasks(mesos_metrics_response)
  end

  before do
    @default_parameters = '--server localhost --value 0'
    @check = MesosLostTasksCheck.new @default_parameters.split(' ')
  end

  describe '#run' do
    it 'tests that a lost tasks metrics are ok' do
      tasks_lost = check_lost '--server localhost --value 42'
      expect(tasks_lost).to be 42
    end

    it 'tests that an empty server response raises an error' do
      expect {@check.check_tasks '{}'}.to raise_error(/No metrics for/)
      expect {@check.check_tasks ''}.to raise_error(/Could not parse JSON/)
    end
  end
end
