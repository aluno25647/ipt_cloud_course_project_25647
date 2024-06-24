#!/bin/bash
MASTER_IP=$1

apt-get update
apt-get install -y postgresql-14

systemctl stop postgresql

# Clear old data
rm -rf /var/lib/postgresql/14/main

# Replicate from master
PGPASSWORD=replicator_password pg_basebackup -h $MASTER_IP -D /var/lib/postgresql/14/main -U replicator -P --wal-method=stream

echo "standby_mode = 'on'" >> /var/lib/postgresql/14/main/recovery.conf
echo "primary_conninfo = 'host=$MASTER_IP port=5432 user=replicator password=replicator_password'" >> /var/lib/postgresql/14/main/recovery.conf
echo "trigger_file = '/tmp/postgresql.trigger.5432'" >> /var/lib/postgresql/14/main/recovery.conf

systemctl start postgresql
