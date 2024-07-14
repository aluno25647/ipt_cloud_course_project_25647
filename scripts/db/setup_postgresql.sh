#!/bin/bash

# Variables
DB_USER="myuser"
DB_PASS="mypassword"
DB_NAME="mydatabase"
MSG_COLOR="\033[0;32m"  # Green color for messages
ERROR_COLOR="\033[0;31m"  # Red color for errors
RESET_COLOR="\033[0m"  # Reset color

echo -e "$MSG_COLOR$(hostname): Install PostgreSQL and its PHP extension$RESET_COLOR"
apt-get update
apt-get install -y postgresql-14 php-pgsql

# Ensure PostgreSQL is listening on all IP addresses
echo -e "$MSG_COLOR$(hostname): Configuring PostgreSQL to listen on all IP addresses$RESET_COLOR"
echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf

# Allow connections from any IP address in the Vagrant network
echo -e "$MSG_COLOR$(hostname): Configuring pg_hba.conf to allow connections from the Vagrant network$RESET_COLOR"
echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/14/main/pg_hba.conf

# Restart PostgreSQL service to apply changes
echo -e "$MSG_COLOR$(hostname): Restarting PostgreSQL service$RESET_COLOR"
service postgresql restart

# Create a new PostgreSQL user and database
echo -e "$MSG_COLOR$(hostname): Creating a new PostgreSQL user and database$RESET_COLOR"
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# Import dump.sql
if [ -f "/vagrant/provision/dump.sql" ]; then
    echo -e "$MSG_COLOR$(hostname): Importing dump.sql and setting user privileges$RESET_COLOR"
    sudo -u postgres psql -d $DB_NAME -f /vagrant/provision/dump.sql

    # Grant user privileges on tables and sequences
    echo -e "$MSG_COLOR$(hostname): Granting user privileges on tables and sequences$RESET_COLOR"
    sudo -u postgres psql -d $DB_NAME -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE messages TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT USAGE, SELECT, UPDATE ON SEQUENCE messages_id_seq TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;"

    # View users and databases in PostgreSQL
    echo -e "$MSG_COLOR$(hostname): Viewing users and databases in PostgreSQL$RESET_COLOR"
    sudo -u postgres psql -c "\du"
    sudo -u postgres psql -c "\list"
    sudo -u postgres psql -d $DB_NAME -c "\dt"
else
    echo -e "${ERROR_COLOR}Error: dump.sql file not found in /vagrant/provision/${RESET_COLOR}"
    exit 1
fi
