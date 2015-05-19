# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "vip.local"
  config.vm.network :private_network, ip: "10.86.73.80"

  config.vm.provider "virtualbox" do |v|
    # Use 1GB of memory
    v.memory = 1024
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet"
    puppet.module_path = "puppet/modules"
  end
end
