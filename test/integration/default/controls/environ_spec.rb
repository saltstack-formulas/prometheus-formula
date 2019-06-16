control 'prometheus configuration environment' do
  title 'should match desired lines'

  describe file('/etc/default/prometheus.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'Your changes may be overwritten' }
    its('content') { should include 'export PATH=${PATH}:/opt/prometheus-2.10.0.linux-amd64' }
  end
end
