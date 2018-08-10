#
# Cookbook:: tomcat
# Recipe:: tomcat_users
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'tomcat::server'

template '/opt/tomcat/conf/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  variables(
    username: node['tomcat']['username'],
    password: node['tomcat']['password']
  )
  action :create
  notifies :restart, 'service[tomcat]', :delayed
end
