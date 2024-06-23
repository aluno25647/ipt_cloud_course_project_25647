#!/bin/bash
MASTER_IP=$1
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install PostgreSQL 14 and its PHP extension\033[0m"
# Install specific version of PostgreSQL
sudo apt-get install -y postgresql-14 php-pgsql

echo -e "$MSG_COLOR$(hostname): Stop PostgreSQL service\033[0m"
sudo systemctl stop postgresql

echo -e "$MSG_COLOR$(hostname): Perform base backup from master\033[0m"
sudo -u postgres pg_basebackup -h $MASTER_IP -D /var/lib/postgresql/14/main -U postgres -v -P --wal-method=stream

echo -e "$MSG_COLOR$(hostname): Configure replication settings\033[0m"
sudo bash -c "cat > /var/lib/postgresql/14/main/recovery.conf <<EOF
standby_mode = 'on'
primary_conninfo = 'host=$MASTER_IP port=5432 user=postgres password=password'
trigger_file = '/tmp/postgresql.trigger.5432'
EOF"

sudo bash -c "cat >> /etc/postgresql/14/main/postgresql.conf <<EOF
hot_standby = on
EOF"

echo -e "$MSG_COLOR$(hostname): Start PostgreSQL service\033[0m"
sudo systemctl start postgresql

# Change back to the previous folder
cd -
