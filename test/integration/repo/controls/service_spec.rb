# frozen_string_literal: true

control 'prometheus services' do
  title 'should be running'

  services =
    case platform[:family]
    when 'redhat'
      %w[
        node_exporter
        prometheus
        blackbox_exporter
        alertmanager
      ]
    else
      %w[
        prometheus
        prometheus-node-exporter
        prometheus-blackbox-exporter
        prometheus-alertmanager
      ]
    end

  node_exporter =
    case platform[:family]
    when 'redhat'
      'node_exporter'
    else
      'prometheus-node-exporter'
    end

  services.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end

    describe file("/etc/default/#{service}") do
      it { should exist }
    end
  end

  # prometheus-node-exporter port
  describe port(9110) do
    it { should be_listening }
  end

  # environ args check
  describe file('/etc/default/prometheus') do
    its('content') { should include '--log.level=debug' }
  end

  describe file("/etc/default/#{node_exporter}") do
    its('content') { should include '--web.listen-address=:9110' }
    its('content') { should include '--log.level=debug' }
  end
end
