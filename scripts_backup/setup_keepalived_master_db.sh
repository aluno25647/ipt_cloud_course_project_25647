#!/bin/bash

cat <<EOF > /etc/keepalived/keepalived.conf
vrrp_instance VI_2 {
    state MASTER;
    interface eth1;
    virtual_router_id 52;
    priority 101;
    advert_int 1;
    virtual_ipaddress {
        192.168.50.110;
    }
}
EOF
