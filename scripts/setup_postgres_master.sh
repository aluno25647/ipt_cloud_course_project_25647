#!/bin/bash

# Instalar PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

# Configurar PostgreSQL para replicação
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'password';"

# Modificar postgresql.conf
sudo bash -c "cat >> /etc/postgresql/12/main/postgresql.conf <<EOF
listen_addresses = '*'
wal_level = replica
max_wal_senders = 3
wal_keep_segments = 64
EOF"

# Replicação
sudo bash -c "cat >> /etc/postgresql/12/main/pg_hba.conf <<EOF
host replication postgres 192.168.50.0/24 md5
host all all 0.0.0.0/0 md5
EOF"

sudo systemctl restart postgresql
