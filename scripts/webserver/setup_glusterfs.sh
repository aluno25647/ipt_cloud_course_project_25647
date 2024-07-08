#!/bin/bash

MSG_COLOR="\033[41m"
NC="\033[0m" # No Color

echo -e "${MSG_COLOR}$(hostname): Installing GlusterFS${NC}"
sudo apt-get update
sudo apt-get install -y glusterfs-server

echo -e "${MSG_COLOR}$(hostname): Starting GlusterFS${NC}"
sudo systemctl start glusterd
sudo systemctl enable glusterd

# Detectar todos os peers disponíveis
GLUSTER_PEERS=""
for peer in $(vagrant status --machine-readable | grep ',provider_name' | cut -d',' -f4); do
    if [[ $peer =~ ^webserver-[0-9]+$ ]]; then
        GLUSTER_PEERS="$GLUSTER_PEERS $peer"
    fi
done

# Remover o espaço inicial, se houver
GLUSTER_PEERS=$(echo $GLUSTER_PEERS | xargs)

echo -e "${MSG_COLOR}$(hostname): Configuring GlusterFS with peers: $GLUSTER_PEERS${NC}"

# Criar o volume GlusterFS se este host é o primeiro na lista
if [ "$(hostname)" == "$(echo $GLUSTER_PEERS | cut -d' ' -f1)" ]; then
    VOLUME_NAME="gv0"
    MOUNT_POINT="/glusterfs/gallery"  # Caminho para armazenar as imagens localmente na VM

    echo -e "${MSG_COLOR}$(hostname): Creating GlusterFS volume $VOLUME_NAME${NC}"
    sudo gluster volume create $VOLUME_NAME replica $(echo $GLUSTER_PEERS | wc -w) transport tcp $GLUSTER_PEERS:/$VOLUME_NAME force
    sudo gluster volume start $VOLUME_NAME

    # Montar o volume GlusterFS em todos os webservers
    for peer in $GLUSTER_PEERS; do
        ssh vagrant@$peer "sudo mkdir -p $MOUNT_POINT"
        ssh vagrant@$peer "sudo mount -t glusterfs localhost:/$VOLUME_NAME $MOUNT_POINT"
        ssh vagrant@$peer "echo localhost:/$VOLUME_NAME $MOUNT_POINT glusterfs defaults,_netdev 0 0 | sudo tee -a /etc/fstab"
    done
fi
