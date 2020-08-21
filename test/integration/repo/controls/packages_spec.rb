# frozen_string_literal: true

case platform[:family]
when 'redhat'
  packages = %w[
    prometheus2
    alertmanager
    node_exporter
  ]
when 'debian'
  packages = %w[
    prometheus
    prometheus-alertmanager
    prometheus-node-exporter
  ]
end

control 'prometheus packages' do
  title 'should be installed'

  packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
