# frozen_string_literal: true

control 'prometheus components' do
  title 'should be installed'

  case platform[:family]
  when 'debian'
    service_dir = '/lib/systemd/system'
    alert_manager_service = 'prometheus-alertmanager'
    node_exporter_service = 'prometheus-node-exporter'
  else
    service_dir = '/usr/lib/systemd/system'
    alert_manager_service = 'alertmanager'
    node_exporter_service = 'node_exporter'
  end

  # describe package('cron') do
  #   it { should be_installed }  # not available on amazonlinux?
  # end
  describe group('prometheus') do
    it { should exist }
  end
  describe user('prometheus') do
    it { should exist }
  end
  describe group('alertmanager') do
    it { should exist }
  end
  describe user('alertmanager') do
    it { should exist }
  end
  describe group('node_exporter') do
    it { should exist }
  end
  describe user('node_exporter') do
    it { should exist }
  end
  describe directory('/var/lib/prometheus') do
    it { should exist }
  end
  describe directory('/opt/prometheus/prometheus-v2.22.1') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/prometheus-v2.22.1/prometheus') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/prometheus') do
    it { should exist }
    its('group') { should eq 'prometheus' }
  end
  describe file("#{service_dir}/prometheus.service") do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe directory('/opt/prometheus/alertmanager-v0.21.0') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/alertmanager-v0.21.0/amtool') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/alertmanager') do
    it { should exist }
    its('group') { should eq 'alertmanager' }
  end
  describe file("#{service_dir}/#{alert_manager_service}.service") do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe directory('/opt/prometheus/node_exporter-v1.0.1') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/node_exporter-v1.0.1/node_exporter') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/node_exporter') do
    it { should exist }
    its('group') { should eq 'node_exporter' }
  end
  describe file("#{service_dir}/#{node_exporter_service}.service") do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe file('/usr/local/sbin/alertmanager') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/sbin/amtool') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/sbin/node_exporter') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/sbin/prometheus') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/sbin/promtool') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/etc/prometheus/prometheus.yml') do
    it { should exist }
    its('group') { should eq 'prometheus' }
    its('mode') { should cmp '0644' }
  end
  describe file('/etc/prometheus/alertmanager.yml') do
    it { should exist }
    its('group') { should eq 'alertmanager' }
    its('mode') { should cmp '0644' }
  end
end
