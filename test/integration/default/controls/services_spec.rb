control 'Prometheus service' do
  impact 0.5
  title 'should be running and enabled'

  describe service('prometheus') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('prometheus-node-exporter') do
    it { should be_enabled }
    it { should be_running }
  end
end
