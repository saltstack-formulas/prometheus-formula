# frozen_string_literal: true

control 'prometheus packages' do
  title 'should be installed'

  packages =
    case platform[:family]
    when 'redhat'
      %w[
        prometheus2
        alertmanager
        node_exporter
      ]
    when 'debian'
      %w[
        prometheus
        prometheus-alertmanager
        prometheus-node-exporter
      ]
    end

  packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
