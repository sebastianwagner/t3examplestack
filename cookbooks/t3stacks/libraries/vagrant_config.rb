# encoding: utf-8

class VagrantConfigHelper

  def self.generate_vagrant_config(vmname, config, node)
    # Vagrant/Virtualbox notes:
    # * it sucks that you have to hardcode "IDE Controller", recent opscode
    #   packer images switched to IDE, but we can't easily detect SATA
    # * virtio network interfaces, in some circumstances, provide MUCH WORSE
    #   performance than good ol' e1000 (the default)
    # * What's the point of the "nonrotational" flag?  tells you the underlying
    #   disk is an SSD.  This should be fine for most of our recent Macs, but I'm
    #   not sure if there's any actual benefit for ext4

    vagrant_config = <<-ENDCONFIG
      config.vm.network 'private_network', ip: "#{config['ipaddress']}"
      config.vm.hostname = "#{config['hostname']}"
      config.vm.provider 'virtualbox' do |v|
        v.customize [
          'modifyvm', :id,
          '--name', "#{vmname}",
          '--memory', "#{config['memory']}",
          '--cpus', "#{config['cpus']}",
          '--natdnshostresolver1', 'on',
          '--usb', 'off',
          '--usbehci', 'off'
        ]
      end
    ENDCONFIG

    vagrant_config
  end

end
