#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'java-1.7.0-openjdk-devel' do
  action :install
end

group 'tomcat' do
  action :create
end

user 'tomcat' do
  group 'tomcat'
  action :create
end

remote_file 'apache-tomcat-8.0.53.tar.gz' do
  path "#{Chef::Config[:file_cache_path]}/apache-tomcat-8.0.53.tar.gz"
  source 'http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-8/v8.0.53/bin/apache-tomcat-8.0.53.tar.gz'
  action :nothing
  notifies :run, 'execute[tar]', :immediately
end

directory '/opt/tomcat' do
  action :create
  notifies :create, 'remote_file[apache-tomcat-8.0.53.tar.gz]', :immediately
end

execute 'tar' do
  command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  cwd Chef::Config[:file_cache_path]
  not_if { ::File.exist?('/opt/tomcat/server/server.xml') }
  action :nothing
  notifies :run, 'execute[chgrp -R tomcat /opt/tomcat/conf]', :delayed
  notifies :run, 'execute[chmod g+rwx /opt/tomcat/conf]', :delayed
  notifies :run, 'execute[chmod g+r /opt/tomcat/conf/*]', :delayed
  notifies :run, 'execute[sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/]', :delayed
  notifies :create, 'template[/opt/tomcat/conf/server.xml]', :delayed
  notifies :create, 'cookbook_file[/etc/systemd/system/tomcat.service]', :delayed
end

execute 'chgrp -R tomcat /opt/tomcat/conf' do
  # commmand 'chgrp -R tomcat /opt/tomcat/conf'
  action :nothing
  subscribes :run, 'execute[tar]', :immediately
end

execute 'chmod g+rwx /opt/tomcat/conf' do
  # command 'chmod g+rwx /opt/tomcat/conf'
  action :nothing
  subscribes :run, 'execute[tar]', :immediately
end

execute 'chmod g+r /opt/tomcat/conf/*' do
  # command 'chmod g+r /opt/tomcat/conf/*'
  action :nothing
  subscribes :run, 'execute[tar]', :immediately
end

execute 'sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/' do
  # command 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
  action :nothing
  subscribes :run, 'execute[tar]', :immediately
end

cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  owner 'root'
  group 'root'
  action :nothing
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

template '/opt/tomcat/conf/server.xml' do
  source 'server.xml.erb'
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  variables(tomcat_port: node['tomcat']['tomcat_port'])
  action :create
  notifies :restart, 'service[tomcat]', :delayed
end

execute 'systemctl daemon-reload' do
  action :nothing
end

service 'tomcat' do
  action :nothing
  subscribes :restart, 'file[/etc/systemd/system/tomcat.service]', :immediately
end
