control 'Prometheus configuration' do
  title 'should match desired lines'

  describe file('/etc/prometheus/prometheus.yml') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'File managed by Salt' }
    its('content') { should include 'Your changes will be overwritten.' }
    its('content') { should include 'global:' }
    its('content') { should include 'alerting:' }
  end
end
