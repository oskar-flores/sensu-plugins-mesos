require_relative './spec_helper.rb'
require_relative '../bin/check-marathon-healthy-app.rb'

# rubocop:disable Style/ClassVars
class MarathonHealthyAppCheck
  at_exit do
    @@autorun = false
  end
end

describe 'MarathonHealthyAppCheck' do
  def check_healthy_ratio(data)
    check = MarathonHealthyAppCheck.new '--warning 0.5 --critical 0.25 --application test_application'.split(' ')
    check.get_healthy_instances_ratio data
  end

  describe '#run' do
    it 'healthy instances are ok' do
      healthy_ratio = check_healthy_ratio '{"app":{"instances":10, "tasksHealthy":10}}'
      expect(healthy_ratio).to eq(1)
    end

    it 'healthy instances are warning' do
      healthy_ratio = check_healthy_ratio '{"app":{"instances":10, "tasksHealthy":4}}'
      expect(healthy_ratio).to eq(0.4)
    end

    it 'healthy instances are critical' do
      healthy_ratio = check_healthy_ratio '{"app":{"instances":10, "tasksHealthy":1}}'
      expect(healthy_ratio).to eq(0.1)
    end

    it 'tests that an empty server response raises an error' do
      expect {check_healthy_ratio '{"app":{"tasksHealthy":10}}'}.to raise_error(/No 'instances' in server response:/)
      expect {check_healthy_ratio '{"app":{"instances":10}}'}.to raise_error(/No 'tasksHealthy' in server response:/)
      expect {check_healthy_ratio ''}.to raise_error(/Could not parse JSON/)
    end
  end
end
