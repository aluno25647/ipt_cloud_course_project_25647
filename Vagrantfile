require 'yaml'

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"

  # Function to create VMs based on Ansible inventory
  def create_vm(config, name, ip, scripts, args=[])
    config.vm.define name do |vm|
      vm.vm.hostname = name
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |v|
        v.name = "Project_A-#{name}"
        v.memory = 1024
        v.cpus = 2
      end
      scripts.each do |script|
        if script.include?('setup_loadbalancer.sh')
          vm.vm.provision "shell", path: script, args: args
        else
          vm.vm.provision "shell", path: script
        end
      end
    end
  end

  # Reading the dynamic inventory
  inventory = YAML.load_file('inventory.yml')

  # Creating VMs based on the inventory
  inventory.each do |group, hosts|
    hosts.each do |host|
      name = host['name']
      ip = host['ip']
      scripts = host['scripts']
      args = host['args'] || []
      create_vm(config, name, ip, scripts, args)
    end
  end
end
