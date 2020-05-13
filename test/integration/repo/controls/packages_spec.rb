# frozen_string_literal: true

control 'prometheus package' do
  title 'should be installed'

  describe package('prometheus') do
    it { should be_installed }
  end
end
