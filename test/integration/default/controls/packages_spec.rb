control 'Prometheus package' do
  title 'should be installed'

  describe package('prometheus') do
    it { should be_installed }
  end

  describe package('prometheus-node-exporter') do
    it { should be_installed }
  end
end
