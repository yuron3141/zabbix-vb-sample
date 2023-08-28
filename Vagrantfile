# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "almalinux/8"

  # Zabbix Manager VM
  config.vm.define :zabbix_ do | zabbix |
    zabbix.vm.hostname = "zabbix"
    zabbix.vm.network :private_network, ip: "192.168.56.10"
    zabbix.vm.network "forwarded_port", guest: 80, host: 8888

    zabbix.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = false
    
        vb.name = "ZabbixManager_on_Alma8"
        # Customize the amount of memory on the VM:
        vb.memory = "1024"
        vb.cpus = 2
    end

    zabbix.vm.provision :shell, :path => "./script/zabbix/provision.sh",:privileged   => true
  end

  # Zabbix Agent VM
  config.vm.define :zabbix_agent do | zabbix_agent |
    zabbix_agent.vm.hostname = "zabbix_agent"
    zabbix_agent.vm.network :private_network, ip: "192.168.56.20"
    zabbix_agent.vm.network "forwarded_port", guest: 80, host: 8889

    zabbix_agent.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = false
  
      vb.name = "ZabbixAgent1_on_Alma8"
      # Customize the amount of memory on the VM:
      vb.memory = "1024"
      vb.cpus = 2
    end

    zabbix_agent.vm.provision :shell, :path => "./script/zabbix_agent/provision.sh",:privileged   => true
  end

end
