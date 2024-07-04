Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-22.04"

  # Consul Server
  config.vm.define "consul-server" do |consul|
    consul.vm.hostname = "consul-server"
    consul.vm.network "private_network", ip: "192.168.50.200"
    consul.vm.provider "virtualbox" do |v|
      v.name = "Project_A-consul"
      v.memory = 1024
      v.cpus = 1
    end
    consul.vm.provision "shell", path: "./scripts/consul/setup_consul.sh"
    consul.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

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
      lb.vm.provision "shell", path: "./scripts/loadbalancer/setup_loadbalancer.sh", args: ["#{i}"]
      lb.vm.provision "shell", path: "./scripts/loadbalancer/register_lb_with_consul.sh", args: ["#{i}"]
      lb.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
    end
  end

  # Web Servers
  (1..2).each do |i|
    config.vm.define vm_name = "webserver-#{i}" do |ws|
      ws.vm.hostname = vm_name
      ws.vm.network "private_network", ip: "192.168.44.#{i+10}"
      ws.vm.provider "virtualbox" do |v|
        v.name = "Project_A-webserver#{i}"
        v.memory = 1024
        v.cpus = 2
      end
      ws.vm.provision "shell", path: "./scripts/webserver/setup_webserver.sh"
      ws.vm.provision "shell", path: "./scripts/webserver/register_webserver_with_consul.sh", args: ["#{i}"]
      ws.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
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
    redis.vm.provision "shell", path: "./scripts/redis/setup_redis.sh"
    redis.vm.provision "shell", path: "./scripts/redis/register_redis_with_consul.sh"
    redis.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

  # GlusterFS Server
  config.vm.define "glusterfs" do |gluster|
    gluster.vm.hostname = "glusterfs"
    gluster.vm.network "private_network", ip: "192.168.44.40"
    gluster.vm.provider "virtualbox" do |v|
      v.name = "Project_A-glusterfs"
      v.memory = 1024
      v.cpus = 2
    end
    gluster.vm.provision "shell", path: "./scripts/glusterfs/setup_glusterfs.sh"
  end

  # Prometheus Server
  config.vm.define "prometheus" do |prom|
    prom.vm.hostname = "prometheus"
    prom.vm.network "private_network", ip: "192.168.44.20"
    prom.vm.provider "virtualbox" do |v|
      v.name = "Project_A-prometheus"
      v.memory = 1048
      v.cpus = 2
    end
    prom.vm.provision "shell", path: "./scripts/prometheus/setup_prometheus.sh"
  end
  
  # Grafana Server
  config.vm.define "grafana" do |grafana|
    grafana.vm.hostname = "grafana"
    grafana.vm.network "private_network", ip: "192.168.44.30"
    grafana.vm.provider "virtualbox" do |v|
      v.name = "Project_A-grafana"
      v.memory = 1048
      v.cpus = 2
    end
    grafana.vm.provision "shell", path: "./scripts/grafana/setup_grafana.sh"
  end

end
