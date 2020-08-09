# frozen_string_literal: true

control 'prometheus components' do
  title 'should be installed'

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
    its('group') { should eq 'prometheus' }
  end
  describe directory('/opt/prometheus/prometheus-v2.10.0') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/prometheus-v2.10.0/prometheus') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/prometheus') do
    it { should exist }
    its('group') { should eq 'prometheus' }
  end
  describe file('/usr/lib/systemd/system/prometheus.service') do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe directory('/opt/prometheus/alertmanager-v0.17.0') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/alertmanager-v0.17.0/amtool') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/alertmanager') do
    it { should exist }
    its('group') { should eq 'alertmanager' }
  end
  describe file('/usr/lib/systemd/system/alertmanager.service') do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe directory('/opt/prometheus/node_exporter-v0.18.1') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/opt/prometheus/node_exporter-v0.18.1/node_exporter') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/var/lib/prometheus/node_exporter') do
    it { should exist }
    its('group') { should eq 'node_exporter' }
  end
  describe file('/usr/lib/systemd/system/node_exporter.service') do
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
