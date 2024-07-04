#!/bin/bash

# Install GlusterFS server packages
sudo apt-get update
sudo apt-get install -y glusterfs-server nfs-kernel-server

# Create and start GlusterFS volume
sudo mkdir -p /data/glusterfs
sudo gluster volume create gv0 192.168.44.40:/data/glusterfs force
sudo gluster volume start gv0

# Mount GlusterFS volume
sudo mkdir -p /mnt/glusterfs
sudo mount -t glusterfs 192.168.44.40:/gv0 /mnt/glusterfs

# Ensure GlusterFS volume mounts on system reboot
echo '192.168.44.40:/gv0 /mnt/glusterfs glusterfs defaults,_netdev 0 0' | sudo tee -a /etc/fstab

# Set permissions on GlusterFS directory
sudo chown -R root:www-data /mnt/glusterfs
sudo chmod -R 775 /mnt/glusterfs

# Configure NFS export
echo '/mnt/glusterfs *(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
