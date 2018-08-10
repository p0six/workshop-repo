# Inspec test for recipe users::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

describe user('chef') do
  it { should exist }
end

describe file('/etc/ssh/sshd_config') do
  its('content') { should match(/^PasswordAuthentication yes$/) }
end
