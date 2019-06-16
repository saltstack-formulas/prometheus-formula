title 'prometheus archives profile'

control 'prometheus tarball archive' do
  impact 1.0
  title 'should be installed'
  desc "Ensure prometheus tarball archive was extracted correctly"

  describe file('/opt/prometheus-2.10.0.linux-amd64') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0755' }
  end

  require 'digest'
  binary = file('/opt/prometheus-2.10.0.linux-amd64/prometheus').content
  sha256sum = Digest::SHA256.hexdigest(binary)
  describe file('/opt/prometheus-2.10.0.linux-amd64/prometheus') do
    its('sha256sum') { should eq '025a7bb0327e1b2b20efbd6e66b8ef81d9020c66f0d5d077b1388a48dec789f7' }
  end

  binary = file('/opt/prometheus-2.10.0.linux-amd64/promtool').content
  sha256sum = Digest::SHA256.hexdigest(binary)
  describe file('/opt/prometheus-2.10.0.linux-amd64/promtool') do
    its('sha256sum') { should eq 'db004c3c0d6a863929a51da5e1fc4a958668e80256ea2a14c5e461fa13656def' }
  end

end
