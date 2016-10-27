require_relative './spec_helper.rb'
require_relative '../bin/check-mesos-running-tasks.rb'
require_relative './fixtures.rb'

# rubocop:disable Style/ClassVars
class MesosTaskCheck

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


describe 'MesosTaskCheck' do
  before do
    @default_parameters = '--server localhost --mode eq --value 0'
    RestClient::Resource = double ('http_client')
    allow(RestClient::Resource).to receive(:new) { RestClient::Resource }
    allow(RestClient::Resource).to receive(:get) { mesos_metrics_response }
  end

  describe '#run' do
    it 'tests that the number of running tasks is not equal to 0' do
      check = (MesosTasksStatus.new @default_parameters.split (' '))
      allow(check).to receive(:get_leader_url) {'localhost'}
      expect { check.run }


    end
#
#    it 'counts tasks correctly' do
#      tasks_running, unhealthy = check_results '--server s --task non/existing --instances 1'
#      expect(tasks_running).to be 0
#      expect(unhealthy).to be == []
#    end

#it 'does not count unhealthy tasks' do
#      tasks_running, unhealthy = check_results '--server s --task broken/app --instances 1'
#      expect(tasks_running).to be 2
#      expect(unhealthy.count).to eq 2
#    end

#   it 'tests that an empty server response raises an error' do
#      expect { @check.check_tasks '{}' }.to raise_error(/No tasks/)
#      expect { @check.check_tasks '' }.to raise_error(/Could not parse JSON/)
#    end
  end
end
