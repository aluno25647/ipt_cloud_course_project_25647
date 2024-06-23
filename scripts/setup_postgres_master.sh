#!/bin/bash

MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install PostgreSQL and its PHP extension\033[0m"
# Install specific version of PostgreSQL
sudo apt-get install -y postgresql-14 php-pgsql

# Change to /tmp directory since the next commands will run as "postgres" user
# to avoid could not change directory to "/home/vagrant": Permission denied
cd /tmp

echo -e "$MSG_COLOR$(hostname): Create a new PostgreSQL user and database\033[0m"
sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
sudo -u postgres psql -c "CREATE DATABASE mydatabase OWNER myuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"

echo -e "$MSG_COLOR$(hostname): Configure PostgreSQL for replication\033[0m"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'password';"

sudo bash -c "cat >> /etc/postgresql/14/main/postgresql.conf <<EOF
listen_addresses = '*'
wal_level = replica
max_wal_senders = 3
wal_keep_segments = 64
EOF"

sudo bash -c "cat >> /etc/postgresql/14/main/pg_hba.conf <<EOF
host replication postgres 192.168.50.0/24 md5
host all all 0.0.0.0/0 md5
EOF"

sudo systemctl restart postgresql

echo -e "$MSG_COLOR$(hostname): Import dump.sql and set user privileges\033[0m"
sudo -u postgres psql -d mydatabase -f /vagrant/provision/dump.sql
sudo -u postgres psql -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE messages TO myuser;"
sudo -u postgres psql -c "GRANT USAGE, SELECT, UPDATE ON SEQUENCE messages_id_seq TO myuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO myuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO myuser;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"

echo -e "$MSG_COLOR$(hostname): View users and databases in PostgreSQL\033[0m"
sudo -u postgres psql -c "\du"
sudo -u postgres psql -c "\list"
sudo -u postgres psql -d mydatabase -c "\dt"

# Change back to the previous folder
cd -
