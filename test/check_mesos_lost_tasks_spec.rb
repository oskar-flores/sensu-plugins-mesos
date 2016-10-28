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
  check.check_tasks(mesos_metrics_response_ko, parameters.split(' ').at(3).to_i)
end

def check_results_ko(parameters)
  check = MesosLostTasksCheck.new parameters.split(' ')
  check.check_tasks(mesos_metrics_response_ko, parameters.split(' ').at(3).to_i)
end

describe 'MesosLostTasksCheck' do
  before do
    @default_parameters = '--server localhost --value 0'
    @check = MesosLostTasksCheck.new @default_parameters.split(' ')
  end

  describe '#run' do
    it 'tests that a lost tasks metrics are ok' do
      expect(check_results @default_parameters).to be 'CheckMesosLostTasks OK'
    end

    it 'tests that a lost tasks metrics are ko' do
      expect(check_results_ko @default_parameters).to be critical 'The number of LOST tasks [42] is bigger than provided [0]!'
    end


    # it 'counts tasks correctly' do
    #   tasks_running, unhealthy = check_results '--server s --task non/existing --instances 1'
    #   expect(tasks_running).to be 0
    #   expect(unhealthy).to be == []
    # end
    #
    # it 'does not count unhealthy tasks' do
    #   tasks_running, unhealthy = check_results '--server s --task broken/app --instances 1'
    #   expect(tasks_running).to be 2
    #   expect(unhealthy.count).to eq 2
    # end
    #
    # it 'tests that an empty server response raises an error' do
    #   expect { @check.check_tasks '{}' }.to raise_error(/No tasks/)
    #   expect { @check.check_tasks '' }.to raise_error(/Could not parse JSON/)
    # end
  end
end
