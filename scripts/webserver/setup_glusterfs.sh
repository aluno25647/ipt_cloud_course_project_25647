# Copy and set up the GlusterFS configuration script
cp /vagrant/scripts/webserver/configure_glusterfs.sh /usr/local/bin/
chmod +x /usr/local/bin/configure_glusterfs.sh

# Copy and set up the systemd service and timer
cp /vagrant/scripts/webserver/check_glusterfs.service /etc/systemd/system/
cp /vagrant/scripts/webserver/check_glusterfs.timer /etc/systemd/system/

# Reload systemd, enable, and start the timer
systemctl daemon-reload
systemctl enable check_glusterfs.timer
systemctl start check_glusterfs.timer