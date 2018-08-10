#
# Cookbook:: users
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

user 'chef' do
  password '$1$wsO.xok0$LPYxrRBOzEWOd/44YzEv4/'
  notifies :create, 'cookbook_file[/etc/ssh/sshd_config]', :immediately
  home '/home/chef'
  manage_home true
  shell '/bin/bash'
  comment 'Some dumb shit..'
  action :create
end

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd_config'
  action :create
  mode '0640'
  notifies :restart, 'service[sshd]', :immediately
end

service 'sshd' do
  action :nothing
end
