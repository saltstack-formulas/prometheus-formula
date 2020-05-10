# frozen_string_literal: true

control 'prometheus configuration environment' do
  title 'should match desired lines'

  args_file = case os[:family]
              when 'debian'
                '/etc/default/prometheus'
              else
                '/etc/default/prometheus.sh'
              end

  describe file(args_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include '--web.listen-address=0.0.0.0:9090' }
  end
end
