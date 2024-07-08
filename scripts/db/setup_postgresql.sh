# Variables
DB_USER="myuser"
DB_PASS="mypassword"
DB_NAME="mydatabase"
MSG_COLOR="\033[0;32m"  # Green color for messages

echo -e "$MSG_COLOR$(hostname): Install PostgreSQL and its PHP extension\033[0m"
apt-get update
apt-get install -y postgresql-14 php-pgsql

# Ensure PostgreSQL is listening on all IP addresses
echo -e "$MSG_COLOR$(hostname): Configuring PostgreSQL to listen on all IP addresses\033[0m"
echo "listen_addresses = '*'" >> /etc/postgresql/14/main/postgresql.conf

# Allow connections from any IP address in the Vagrant network
echo -e "$MSG_COLOR$(hostname): Configuring pg_hba.conf to allow connections from the Vagrant network\033[0m"
echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/14/main/pg_hba.conf

# Restart PostgreSQL service to apply changes
echo -e "$MSG_COLOR$(hostname): Restarting PostgreSQL service\033[0m"
service postgresql restart

# Create a new PostgreSQL user and database
echo -e "$MSG_COLOR$(hostname): Creating a new PostgreSQL user and database\033[0m"
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

# Import dump.sql
if [ -f "/vagrant/provision/dump.sql" ]; then
    echo -e "$MSG_COLOR$(hostname): Importing dump.sql and setting user privileges\033[0m"
    sudo -u postgres psql -d $DB_NAME -f /vagrant/provision/dump.sql

    # Grant user privileges on tables and sequences
    echo -e "$MSG_COLOR$(hostname): Granting user privileges on tables and sequences\033[0m"
    sudo -u postgres psql -d $DB_NAME -c "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE messages TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT USAGE, SELECT, UPDATE ON SEQUENCE messages_id_seq TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;"
    sudo -u postgres psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;"

    # View users and databases in PostgreSQL
    echo -e "$MSG_COLOR$(hostname): Viewing users and databases in PostgreSQL\033[0m"
    sudo -u postgres psql -c "\du"
    sudo -u postgres psql -c "\list"
    sudo -u postgres psql -d $DB_NAME -c "\dt"
else
    echo "Error: dump.sql file not found in /vagrant/provision/"
    exit 1
fi