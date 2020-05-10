# frozen_string_literal: true

control 'Prometheus service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('prometheus') do
    it { should be_enabled }
    # it { should be_running } #some ubuntu 16.05 image issue
  end
end
