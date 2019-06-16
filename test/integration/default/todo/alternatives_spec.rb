title 'linux alternatives profile'

control 'prometheus linux alternatives' do
  impact 1.0
  title 'should be installed'
  desc "Ensure prometheus linux alternatives are correct"
  tag: package: "tarball archive"

  describe file('/opt/prometheus') do         # prometheus-home alternative
    it { should be_symlink }
    it { should_not be_file }
    it { should_not be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('shallow_link_path') { should eq '/etc/alternatives/prometheus-home' }
  end

  describe file('/usr/bin/prometheus') do         # prometheus alternative
    it { should be_symlink }
    it { should_not be_file }
    it { should_not be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('shallow_link_path') { should eq '/etc/alternatives/link-prometheus' }
  end

  describe file('/usr/bin/promtool') do         # promtool alternative
    it { should be_symlink }
    it { should_not be_file }
    it { should_not be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('shallow_link_path') { should eq '/etc/alternatives/link-promtool' }
  end

end
