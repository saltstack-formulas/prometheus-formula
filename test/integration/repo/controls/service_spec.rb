# frozen_string_literal: true

control 'prometheus services' do
  title 'should be running'

  service =
    case platform[:family]
    when 'redhat'
      'node_exporter'
    else
      'prometheus-node-exporter'
    end

  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end

  # prometheus-node-exporter port
  describe port(9100) do
    it { should be_listening }
  end
end
