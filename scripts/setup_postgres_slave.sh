#!/bin/bash
MASTER_IP=$1

# Instalar PostgreSQL #versao 12 cuz ubuntu-20.04
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib

# Parar o serviço PostgreSQL
sudo systemctl stop postgresql

# Fazer o backup do master
sudo -u postgres bash -c "pg_basebackup -h $MASTER_IP -D /var/lib/postgresql/12/main -U postgres -v -P --wal-method=stream"

# Configurar PostgreSQL replicação
sudo bash -c "cat > /var/lib/postgresql/12/main/recovery.conf <<EOF
standby_mode = 'on'
primary_conninfo = 'host=$MASTER_IP port=5432 user=postgres password=password'
trigger_file = '/tmp/postgresql.trigger.5432'
EOF"

# postgresql.conf
sudo bash -c "cat >> /etc/postgresql/12/main/postgresql.conf <<EOF
hot_standby = on
EOF"

sudo systemctl start postgresql
