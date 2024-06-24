Vagrant.configure("2") do |config|

  # Load Balancer 1
  config.vm.define "loadbalancer1" do |lb1|
    lb1.vm.box = "bento/ubuntu-22.04"
    lb1.vm.network "private_network", ip: "192.168.50.10"
    lb1.vm.hostname = "loadbalancer1"
    lb1.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer1"
      v.memory = 1024
      v.cpus = 2
    end
    lb1.vm.provision "shell", path: "scripts/setup_loadbalancer.sh", args: ["1"]
  end

  # Load Balancer 2
  config.vm.define "loadbalancer2" do |lb2|
    lb2.vm.box = "bento/ubuntu-22.04"
    lb2.vm.network "private_network", ip: "192.168.50.20"
    lb2.vm.hostname = "loadbalancer2"
    lb2.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer2"
      v.memory = 1024
      v.cpus = 2
    end
    lb2.vm.provision "shell", path: "./scripts/setup_loadbalancer.sh", args: ["2"]
  end

  # Web Server 1
  config.vm.define "webserver1" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "webserver1"
    node.vm.network :private_network, ip: "192.168.44.11"
    node.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver1"
      v.memory = 1024
      v.cpus = 2
    end
    node.vm.provision "shell", path: "./scripts/setup_webserver.sh"
  end

  # Web Server 2
  config.vm.define "webserver2" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "webserver2"
    node.vm.network :private_network, ip: "192.168.44.12"
    node.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver2"
      v.memory = 1024
      v.cpus = 2
    end
    node.vm.provision "shell", path: "./scripts/setup_webserver.sh"
  end

  # Web Server 3
  config.vm.define "webserver3" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "webserver3"
    node.vm.network :private_network, ip: "192.168.44.13"
    node.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver3"
      v.memory = 1024
      v.cpus = 2
    end
    node.vm.provision "shell", path: "./scripts/setup_webserver.sh"
  end

   # Database Master
   config.vm.define "dbmaster" do |db|
    db.vm.box = "bento/ubuntu-22.04"
    db.vm.hostname = "dbmaster"
    db.vm.network :private_network, ip: "192.168.60.10"
    db.vm.provider "virtualbox" do |v|
      v.name = "Project_A-dbmaster"
      v.memory = 1024
      v.cpus = 2
    end
    db.vm.provision "shell", path: "./scripts/db_master.sh"
  end

  # Database Slave 1
  config.vm.define "dbslave1" do |db|
    db.vm.box = "bento/ubuntu-22.04"
    db.vm.hostname = "dbslave1"
    db.vm.network :private_network, ip: "192.168.60.11"
    db.vm.provider "virtualbox" do |v|
      v.name = "Project_A-dbslave1"
      v.memory = 1024
      v.cpus = 2
    end
    db.vm.provision "shell", path: "./scripts/db_slave.sh", args: ["192.168.60.10"]
  end

  # Database Slave 2
  config.vm.define "dbslave2" do |db|
    db.vm.box = "bento/ubuntu-22.04"
    db.vm.hostname = "dbslave2"
    db.vm.network :private_network, ip: "192.168.60.12"
    db.vm.provider "virtualbox" do |v|
      v.name = "Project_A-dbslave2"
      v.memory = 1024
      v.cpus = 2
    end
    db.vm.provision "shell", path: "./scripts/db_slave.sh", args: ["192.168.60.10"]
  end


end
