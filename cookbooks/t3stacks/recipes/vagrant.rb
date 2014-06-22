require 'cheffish'
require 'chef_metal_vagrant'


vms_dir = node['t3stacks']['vms_dir']

# creat vms_dir and assign to vagrant_cluster
directory vms_dir
vagrant_cluster vms_dir

# set vagrant box
vagrant_box 'debian-7-amd64' do
    url 'http://boxes.datenbetrieb.de/debian-7-amd64.box'
end


#directory repo_path
#with_chef_local_server :chef_repo_path => repo_path,
#  :cookbook_path => [ File.join(repo_path, 'cookbooks'),
#    File.join(repo_path, 'vendor', 'cookbooks') ]


# set provisioner options for all of our machines
node['t3stacks']['machines'].each do |vmname, config|
  additional_vagrant_config = {
    ':vagrant_config' => VagrantConfigHelper.generate_vagrant_config(vmname, config, node)
  }
  #node.set['t3stacks']['provisioner_options'][vmname] = run_context.chef_metal.current_machine_options.merge(additional_vagrant_config)
end
