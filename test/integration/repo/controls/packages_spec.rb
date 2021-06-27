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
    when 'linux'
      case platform[:name]
      when 'arch'
        %w[
          prometheus
          alertmanager
          prometheus-node-exporter
        ]
      end
    else
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
