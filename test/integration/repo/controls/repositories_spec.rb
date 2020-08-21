# frozen_string_literal: true

control 'repositories' do
  impact 0.6
  title 'Configure the repositories'
  desc '
    Configure the Debian/RedHat repositories for the supported platforms.
  '
  tag 'repositories', 'apt', 'yum'
  ref 'Prometheus prerequisites - Section: Prometheus package repositories', url: 'https://prometheus.io/download'

  case os[:family]
  when 'debian'
    describe file('/etc/apt/sources.list.d/prometheus.list') do
      it { should_not exist }
    end
  when 'redhat', 'centos'
    describe yum.repo('prometheus') do
      it { should exist }
      it { should be_enabled }
    end
  end
end
