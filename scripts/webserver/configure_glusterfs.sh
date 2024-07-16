#!/bin/bash

# Define colors
MSG_COLOR="\033[41m"    # Red background color for messages
NC="\033[0m"            # No Color

configure_glusterfs() {
    echo -e "${MSG_COLOR}$(hostname): Configuring GlusterFS${NC}"
    sudo apt-get install -y glusterfs-server

    echo -e "${MSG_COLOR}$(hostname): Starting GlusterFS${NC}"
    sudo systemctl start glusterd
    sudo systemctl enable glusterd

    # Detect all available peers
    GLUSTER_PEERS=""
    for peer in $(consul members | grep web-server | awk '{print $2}' | cut -d':' -f1); do
        GLUSTER_PEERS="$GLUSTER_PEERS $peer"
    done

    # Remove leading space if present
    GLUSTER_PEERS=$(echo $GLUSTER_PEERS | xargs)

    echo -e "${MSG_COLOR}$(hostname): Configuring GlusterFS with peers: $GLUSTER_PEERS${NC}"

    # Create GlusterFS volume if this host is the first in the list
    if [ "$(hostname)" == "$(echo $GLUSTER_PEERS | cut -d' ' -f1)" ]; then
        VOLUME_NAME="gv0"
        MOUNT_POINT="/glusterfs/gallery"  # Path to store images locally in the VM

        echo -e "${MSG_COLOR}$(hostname): Creating GlusterFS volume $VOLUME_NAME${NC}"
        sudo gluster volume create $VOLUME_NAME replica $(echo $GLUSTER_PEERS | wc -w) transport tcp $GLUSTER_PEERS:/$VOLUME_NAME force
        sudo gluster volume start $VOLUME_NAME

        # Mount the GlusterFS volume on all webservers
        for peer in $GLUSTER_PEERS; do
            ssh vagrant@$peer "sudo mkdir -p $MOUNT_POINT"
            ssh vagrant@$peer "sudo mount -t glusterfs localhost:/$VOLUME_NAME $MOUNT_POINT"
            ssh vagrant@$peer "echo localhost:/$VOLUME_NAME $MOUNT_POINT glusterfs defaults,_netdev 0 0 | sudo tee -a /etc/fstab"
        done
    fi
}

# Run the configuration function
configure_glusterfs
