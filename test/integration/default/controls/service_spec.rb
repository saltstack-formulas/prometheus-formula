# frozen_string_literal: true

control 'services with a consistent service name on each distro' do
  title 'should be running'

  distro_services =
    case platform[:family]
    when 'debian'
      %w[
        prometheus
        prometheus-alertmanager
        prometheus-node-exporter
        prometheus-blackbox-exporter
      ]
    else
      %w[
        prometheus
        alertmanager
        node_exporter
        blackbox_exporter
      ]
    end

  distro_services.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end
  end

  # blackbox_exporter port
  describe port(9115) do
    it { should be_listening }
  end
end

control 'services with any service name we want to give them' do
  title 'should be running'

  # if we set a service name in the pillar,
  # the formula should work, no matter what it is or the
  # install method we choose

  describe service('my-fancy-consul-exporter-service') do
    it { should be_enabled }
    it { should be_running }
  end

  # consul_exporter port
  describe port(9107) do
    it { should be_listening }
  end
end
