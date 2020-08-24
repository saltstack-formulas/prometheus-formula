# frozen_string_literal: true

control 'prometheus services' do
  title 'should be running'

  describe service('node_exporter') do
    it { should be_enabled }
    it { should be_running }
  end

  # node_exporter port
  describe port(9100) do
    it { should be_listening }
  end
end
