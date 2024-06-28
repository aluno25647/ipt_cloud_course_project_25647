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

  # Redis Server
  config.vm.define "redis-server" do |redis|
    redis.vm.hostname = "redis-server"
    redis.vm.network "private_network", ip: "192.168.44.10"
    redis.vm.provider "virtualbox" do |v|
      v.name = "Project_A-redis"
      v.memory = 1024
      v.cpus = 1
    end
    redis.vm.provision "shell", path: "scripts/setup_redis.sh"
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

end
