#!/bin/bash

cat <<EOF > /etc/keepalived/keepalived.conf
vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    virtual_ipaddress {
        192.168.50.100
    }
}
EOF

systemctl restart keepalived
