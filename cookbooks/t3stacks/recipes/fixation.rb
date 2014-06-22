#
# Cookbook Name:: t3stacks
# Recipe:: default
#
# Copyright (C) 2014 
#
# 
require 'chef_metal'

# fixation on *review*
# allow any login on review and create user admin
# remove crontab (syncing users/groups with api will fail due to missing permissions on typo3.org)
if node['t3stacks']['enabled'].include? 'review' and node['t3stacks']['machines']['review'] and node['t3stacks']['machines']['review']['fixation'] 
  machine_execute "fix stuff on review" do
    # crontab -l | sed 's/ebian/xxxx/p' | crontab -
    command <<EOM
sed -i -e 's/exit(1)/exit(0)/' /var/gerrit/scripts/typo3org-authentication.php
sudo curl -k "https://admin:egal@#{node['t3stacks']['machines']['review']['hostname']}/login/"
sudo crontab -u gerrit -r
true
EOM
    machine "review"
  end
end

# curl -k --basic --user admin:xxx -X POST -d @${echo ~/.ssh/id_rsa_gerritrobot.pub} https://review.typo3.vagrant/a/accounts/self/sshkeys
