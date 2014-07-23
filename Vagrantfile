# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.provision "shell", path: "vagrant-ubuntu-install.sh", privileged: false
  # Rails
  config.vm.network :forwarded_port, host: 3003, guest: 3000
  # Jasmine
  config.vm.network :forwarded_port, host: 8888, guest: 8888
  config.vm.synced_folder ".", "/WebsiteOne", type: "rsync"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end
end
