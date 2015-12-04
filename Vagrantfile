# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  # TODO: check the resultant hostname is valid, e.g. no spaces
  config.vm.hostname = 'vip-go.local'
  config.vm.network "private_network", type: "dhcp"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./go-client-repo/themes", "/var/www/wp-content/themes", nfs: true, create: true
  config.vm.synced_folder "./go-client-repo/plugins", "/var/www/wp-content/plugins", nfs: true, create: true

  # Optional folder, only present if sites require languages other than English (US)
  if File.directory?("./go-client-repo/languages")
    config.vm.synced_folder "./go-client-repo/languages", "/var/www/wp-content/languages", nfs: true, create: false
  end

  config.vm.provider "virtualbox" do |v|
    # Use 1GB of memory
    v.memory = 1024
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet"
    puppet.module_path = "puppet/modules"
    puppet.facter = {
        "hostname"          => config.vm.hostname,
        "client"            => ENV['VIP_GO_CLIENT'],
        "client_git_repo"   => ENV['VIP_GO_CLIENT_GIT']
    }
  end
end
