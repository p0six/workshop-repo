# Inspec test for recipe tomcat::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('java-1.7.0-openjdk-devel') do
  it { should be_installed }
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  its('group') { should eq 'tomcat' }
end

describe file('/opt/tomcat') do
  it { should be_directory }
end

describe file('/opt/tomcat/RELEASE-NOTES') do
  it { should exist }
end

describe file('/opt/tomcat/conf') do
  its('group') { should eq 'tomcat' }
  # it { should be_allowed('full-control', by_group: 'tomcat') }
  it { should be_readable.by('group') }
  it { should be_writable.by('group') }
  it { should be_writable.by('group') }
end

describe file('/opt/tomcat/conf/server.xml') do
  its('group') { should eq 'tomcat' }
  it { should be_allowed('read', by_group: 'tomcat') }
end

%w[/opt/tomcat/webapps /opt/tomcat/work /opt/tomcat/temp /opt/tomcat/logs].each do |folder|
  describe file(folder) do
    its('owner') { should eq 'tomcat' }
  end
end

describe file('/etc/systemd/system/tomcat.service') do
  its('content') { should match(/Apache Tomcat Web Application Container/) }
end

describe command('curl http://localhost:8181') do
  its('stdout') { should match(%r{Apache Tomcat\/8.0.53}) }
end
