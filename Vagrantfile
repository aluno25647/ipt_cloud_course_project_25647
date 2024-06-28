Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-22.04"

  # Load Balancers
  (1..2).each do |i|
    config.vm.define vm_name = "loadbalancer-#{i}" do |lb|
      lb.vm.hostname = vm_name
      lb.vm.network "private_network", ip: "192.168.50.#{i}0"
      lb.vm.provider "virtualbox" do |v|
        v.name = "Project_A-loadbalancer#{i}"
        v.memory = 1024
        v.cpus = 2
      end
      lb.vm.provision "shell", path: "scripts/setup_loadbalancer.sh", args: ["#{i}"]
    end
  end

  # Web Servers
  (1..3).each do |i|
    config.vm.define vm_name = "webserver-#{i}" do |ws|
      ws.vm.hostname = vm_name
      ws.vm.network "private_network", ip: "192.168.44.#{i+10}"
      ws.vm.provider "virtualbox" do |v|
        v.name = "Project_A-webserver#{i}"
        v.memory = 1024
        v.cpus = 2
      end
      ws.vm.provision "shell", path: "./scripts/setup_webserver.sh"
    end
  end


  #  # Database Master
  #  config.vm.define "dbmaster" do |db|
  #   db.vm.box = "bento/ubuntu-22.04"
  #   db.vm.hostname = "dbmaster"
  #   db.vm.network :private_network, ip: "192.168.60.10"
  #   db.vm.provider "virtualbox" do |v|
  #     v.name = "Project_A-dbmaster"
  #     v.memory = 1024
  #     v.cpus = 2
  #   end
  #   db.vm.provision "shell", path: "./scripts/db_master.sh"
  # end

  # # Database Slave 1
  # config.vm.define "dbslave1" do |db|
  #   db.vm.box = "bento/ubuntu-22.04"
  #   db.vm.hostname = "dbslave1"
  #   db.vm.network :private_network, ip: "192.168.60.11"
  #   db.vm.provider "virtualbox" do |v|
  #     v.name = "Project_A-dbslave1"
  #     v.memory = 1024
  #     v.cpus = 2
  #   end
  #   db.vm.provision "shell", path: "./scripts/db_slave.sh", args: ["192.168.60.10"]
  # end

  # # Database Slave 2
  # config.vm.define "dbslave2" do |db|
  #   db.vm.box = "bento/ubuntu-22.04"
  #   db.vm.hostname = "dbslave2"
  #   db.vm.network :private_network, ip: "192.168.60.12"
  #   db.vm.provider "virtualbox" do |v|
  #     v.name = "Project_A-dbslave2"
  #     v.memory = 1024
  #     v.cpus = 2
  #   end
  #   db.vm.provision "shell", path: "./scripts/db_slave.sh", args: ["192.168.60.10"]
  # end


end
