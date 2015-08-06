# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "vip.local"
  config.vm.network :private_network, ip: "10.86.73.80"

# define is_windows used for determinig whether we should or not use nfs
# todo: use samba for windows?
  is_windows = RUBY_PLATFORM.downcase.include?("w32");

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./themes", "/var/www/wp-content/themes", nfs: !is_windows, create: true
  config.vm.synced_folder "./plugins", "/var/www/wp-content/plugins", nfs: !is_windows, create: true

  config.vm.provider "virtualbox" do |v|
    # Use 1GB of memory
    v.memory = 1024
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet"
    puppet.module_path = "puppet/modules"
  end
end
