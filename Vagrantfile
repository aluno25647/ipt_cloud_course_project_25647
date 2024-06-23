Vagrant.configure("2") do |config|

  # Load Balancer 1 (Web-Master)
  config.vm.define "loadbalancer1" do |lb1|
    lb1.vm.box = "bento/ubuntu-20.04"
    lb1.vm.network "private_network", ip: "192.168.50.10"
    lb1.vm.hostname = "loadbalancer1"
    lb1.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer1"
      v.memory = 512
      v.cpus = 2
      v.linked_clone = true
    end
    lb1.vm.provision "shell", path: "scripts/setup_loadbalancer.sh"
    lb1.vm.provision "shell", path: "scripts/setup_keepalived_master.sh"
  end

  # Load Balancer 2 (Web-Backup)
  config.vm.define "loadbalancer2" do |lb2|
    lb2.vm.box = "bento/ubuntu-20.04"
    lb2.vm.network "private_network", ip: "192.168.50.20"
    lb2.vm.hostname = "loadbalancer2"
    lb2.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer2"
      v.memory = 512
      v.cpus = 2
      v.linked_clone = true
    end
    lb2.vm.provision "shell", path: "scripts/setup_loadbalancer.sh"
    lb2.vm.provision "shell", path: "scripts/setup_keepalived_backup.sh"
  end


  # Web Server 1
  config.vm.define "webserver1" do |web1|
    web1.vm.box = "bento/ubuntu-20.04"
    web1.vm.network "private_network", ip: "192.168.50.11"
    web1.vm.hostname = "webserver1"
    web1.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver1"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    web1.vm.provision "shell", path: "scripts/setup_webserver.sh"  ## TODO
  end

  # Web Server 2
  config.vm.define "webserver2" do |web2|
    web2.vm.box = "bento/ubuntu-20.04"
    web2.vm.network "private_network", ip: "192.168.50.12"
    web2.vm.hostname = "webserver2"
    web2.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver2"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    web2.vm.provision "shell", path: "scripts/setup_webserver.sh"  ## TODO
  end

  # Web Server 3
  config.vm.define "webserver3" do |web3|
    web3.vm.box = "bento/ubuntu-20.04"
    web3.vm.network "private_network", ip: "192.168.50.13"
    web3.vm.hostname = "webserver3"
    web3.vm.provider "virtualbox" do |v|
      v.name = "Project_A-webserver3"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    web3.vm.provision "shell", path: "scripts/setup_webserver.sh"  ## TODO
  end


  # Load Balancer 3 (Web-Master)
  config.vm.define "loadbalancer3" do |lb3|
    lb3.vm.box = "bento/ubuntu-20.04"
    lb3.vm.network "private_network", ip: "192.168.50.30"
    lb3.vm.hostname = "loadbalancer3"
    lb3.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer3"
      v.memory = 512
      v.cpus = 2
      v.linked_clone = true
    end
    lb3.vm.provision "shell", path: "scripts/setup_loadbalancer_db.sh"
    lb3.vm.provision "shell", path: "scripts/setup_keepalived_master_db.sh"
  end

  # Load Balancer 4 (Web-Backup)
  config.vm.define "loadbalancer4" do |lb4|
    lb4.vm.box = "bento/ubuntu-20.04"
    lb4.vm.network "private_network", ip: "192.168.50.40"
    lb4.vm.hostname = "loadbalancer4"
    lb4.vm.provider "virtualbox" do |v|
      v.name = "Project_A-loadbalancer4"
      v.memory = 512
      v.cpus = 2
      v.linked_clone = true
    end
    lb4.vm.provision "shell", path: "scripts/setup_loadbalancer_db.sh"
    lb4.vm.provision "shell", path: "scripts/setup_keepalived_backup_db.sh"
  end


  # DB Master
  config.vm.define "db_master" do |master|
    master.vm.box = "bento/ubuntu-20.04"
    master.vm.network "private_network", ip: "192.168.50.31"
    master.vm.hostname = "db_master"
    master.vm.provider "virtualbox" do |v|
      v.name = "Project_A-db_master"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    master.vm.provision "shell", path: "scripts/setup_postgres_master.sh"
  end

 # DB Slave 1
  config.vm.define "db_slave1" do |slave1|
    slave1.vm.box = "bento/ubuntu-20.04"
    slave1.vm.network "private_network", ip: "192.168.50.32"
    slave1.vm.hostname = "db_slave1"
    slave1.vm.provider "virtualbox" do |v|
      v.name = "Project_A-db_slave1"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    slave1.vm.provision "shell", path: "scripts/setup_postgres_slave.sh", args: ["192.168.50.31"]
  end

  # DB Slave 2
  config.vm.define "db_slave2" do |slave2|
    slave2.vm.box = "bento/ubuntu-20.04"
    slave2.vm.network "private_network", ip: "192.168.50.33"
    slave2.vm.hostname = "db_slave2"
    slave2.vm.provider "virtualbox" do |v|
      v.name = "Project_A-db_slave2"
      v.memory = 1024
      v.cpus = 2
      v.linked_clone = true
    end
    slave2.vm.provision "shell", path: "scripts/setup_postgres_slave.sh", args: ["192.168.50.31"]
  end


end
