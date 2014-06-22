#
# Cookbook Name:: metaltest
# Recipe:: default
#
# Copyright (C) 2014 
#
# 
require 'chef_metal'

#def chef_repo_path
#   "/srv/fileserver/projekte/t3-team-server/chef/"
#end

provider = node['t3stacks']['provider']
include_recipe("t3stacks::#{provider}")

# create environment
chef_environment "pre-production" do
    action :create
end

# run through machines and create nodes + machines
node['t3stacks']['enabled'].each do |name|
  config = node['t3stacks']['machines'][name]
  # create node
  chef_node name do
      chef_environment "pre-production"
      # dev_mode is for chef-vault plain text databags
      attribute 'dev_mode', true
      #puts config[:run_list]
      #recipe_list = config[:run_list].collect {|r| "recipe[" + r + "]"}
      #run_list recipe_list
      action :create
  end

  # create machine
  machine name do
      action [:converge]
      converge true
      chef_environment = "pre-production"
      # @todo handle other options like cpu/ram
      add_machine_options :vagrant_options => {
        'vm.hostname' => config[:hostname],
        }, :vagrant_config => <<-EOM
        config.vm.network "private_network", ip: "#{config[:ipaddress]}"
        config.vm.provider 'virtualbox' do |v|
            v.customize [
              'modifyvm', :id,
              '--name', "#{config[:hostname]}"
            ]
        end
      EOM
      # @todo attribute precedence? profiles for dev and live?
      config[:attributes].each do |attribute_name, attribute_config|
        attribute attribute_name, attribute_config
      end
      #attribute 'site-forgetypo3org', {ssl_certificate: 'wildcard.vagrant', sso_enabled: false}
      #attribute 'redmine', {hostname: 'forge.typo3.vagrant', database: {password: 'duenuiexvglhc'}}
      config[:run_list].each do |recipe_name|
        recipe recipe_name
      end
      #recipe 'site-forgetypo3org'
  end
end
