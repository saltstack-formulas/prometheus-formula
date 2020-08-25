# frozen_string_literal: true

control 'services with a consistent service name across distros' do
  title 'should be running'

  # we forced node_exporter's service name to `node_exporter` in the pillar,
  # so its name will be the same across distros for this test
  describe service('node_exporter') do
    it { should be_enabled }
    it { should be_running }
  end

  # node_exporter port
  describe port(9100) do
    it { should be_listening }
  end
end

control 'services with a consistent service name on each distro' do
  title 'should be running'

  # if we don't set a service name in the pillar,
  # its name will be the same on each distro, no matter what the
  # install method we choose

  distro_service =
    case platform[:family]
    when 'debian'
      'prometheus-blackbox-exporter'
    else
      'blackbox_exporter'
    end

  describe service(distro_service) do
    it { should be_enabled }
    it { should be_running }
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
