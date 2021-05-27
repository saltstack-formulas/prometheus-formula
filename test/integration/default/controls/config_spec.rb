# frozen_string_literal: true

control 'prometheus configuration files' do
  title 'should exist'

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
  describe file('/etc/prometheus/first_rules.yml') do
    it { should exist }
    its('group') { should eq 'alertmanager' }
    its('mode') { should cmp '0644' }
  end
  describe file('/etc/prometheus/subdir/second.yml') do
    it { should exist }
    its('group') { should eq 'alertmanager' }
    its('mode') { should cmp '0644' }
  end
end
