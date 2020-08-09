# frozen_string_literal: true

control 'prometheus package' do
  title 'should be installed'

  describe package('prometheus2') do
    it { should be_installed }
  end
end
