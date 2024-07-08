Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-22.04"

  # Consul Server
  config.vm.define "consul-server" do |consul|
    consul.vm.hostname = "consul-server"
    consul.vm.network "private_network", ip: "192.168.50.200"
    consul.vm.provider "virtualbox" do |v|
      v.name = "Project_A-consul"
      v.memory = 768
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
      ws.vm.provision "shell", path: "./scripts/webserver/setup_glusterfs.sh"
      ws.vm.provision "shell", path: "./scripts/webserver/register_webserver_with_consul.sh", args: ["#{i}"]
      ws.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
    end
  end

  # Database Server
  config.vm.define "database-server" do |db|
    db.vm.hostname = "database-server"
    db.vm.network "private_network", ip: "192.168.50.80"
    db.vm.provider "virtualbox" do |v|
      v.name = "Project_A-database"
      v.memory = 1024
      v.cpus = 2
    end
    db.vm.provision "shell", path: "./scripts/db/setup_postgresql.sh"
    db.vm.provision "shell", path: "./scripts/db/register_database_with_consul.sh"
    db.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

  # Sessions Server
  config.vm.define "sessions-server" do |redis|
    redis.vm.hostname = "sessions-server"
    redis.vm.network "private_network", ip: "192.168.50.30"
    redis.vm.provider "virtualbox" do |v|
      v.name = "Project_A-sessions"
      v.memory = 768
      v.cpus = 1
    end
    redis.vm.provision "shell", path: "./scripts/sessions/setup_redis.sh"
    redis.vm.provision "shell", path: "./scripts/sessions/register_sessions_with_consul.sh"
    redis.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

  # WebSockets Server
  config.vm.define "websockets-server" do |websockets|
    websockets.vm.hostname = "websockets-server"
    websockets.vm.network "private_network", ip: "192.168.50.50"
    websockets.vm.provider "virtualbox" do |v|
      v.name = "Project_A-websockets"
      v.memory = 768
      v.cpus = 1
    end
    websockets.vm.provision "shell", path: "./scripts/websockets/setup_websockets.sh"
    websockets.vm.provision "shell", path: "./scripts/websockets/register_websockets_with_consul.sh"
    websockets.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

  # Prometheus Server
  config.vm.define "prometheus" do |prom|
    prom.vm.hostname = "prometheus"
    prom.vm.network "private_network", ip: "192.168.50.60"
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
    grafana.vm.network "private_network", ip: "192.168.50.70"
    grafana.vm.provider "virtualbox" do |v|
      v.name = "Project_A-grafana"
      v.memory = 1048
      v.cpus = 1
    end
    grafana.vm.provision "shell", path: "./scripts/grafana/setup_grafana.sh"
    grafana.vm.provision "shell", path: "./scripts/prometheus/setup_node_exporter.sh"
  end

end
