#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'tomcat::server'
include_recipe 'tomcat::tomcat_users'
