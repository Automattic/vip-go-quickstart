# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  # TODO: check the resultant hostname is valid, e.g. no spaces
  config.vm.hostname = File.basename( File.dirname(__FILE__) ) + "-vip-go.local"
  config.vm.network "private_network", type: "dhcp"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./themes", "/var/www/wp-content/themes", nfs: true, create: true
  config.vm.synced_folder "./plugins", "/var/www/wp-content/plugins", nfs: true, create: true

  config.vm.provider "virtualbox" do |v|
    # Use 1GB of memory
    v.memory = 1024
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet"
    puppet.module_path = "puppet/modules"
    puppet.facter = {
    	"quickstart_domain" => config.vm.hostname
    }
  end
end
