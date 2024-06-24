#!/bin/bash
apt-get update
apt-get install -y postgresql-14

# Configure PostgreSQL for master
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/14/main/postgresql.conf
echo "host replication all 192.168.60.0/24 md5" >> /etc/postgresql/14/main/pg_hba.conf

sudo -u postgres psql -c "CREATE ROLE replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'replicator_password';"

systemctl restart postgresql
