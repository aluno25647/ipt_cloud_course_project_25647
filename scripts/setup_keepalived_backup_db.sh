#!/bin/bash
apt-get update
apt-get install -y keepalived

cat <<EOL > /etc/keepalived/keepalived.conf
vrrp_instance VI_2 {
    state BACKUP
    interface eth0
    virtual_router_id 52
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    virtual_ipaddress {
        192.168.50.110
    }
}
EOL

systemctl restart keepalived
