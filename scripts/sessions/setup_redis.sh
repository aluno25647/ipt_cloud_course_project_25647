#!/bin/bash

# Define colors
MSG_COLOR="\033[41m"    # Red background color for messages
RESET_COLOR="\033[0m"   # Reset color

# Echo statements with colorized output
echo -e "${MSG_COLOR}$(hostname): Update package lists${RESET_COLOR}"
sudo apt-get update

echo -e "${MSG_COLOR}$(hostname): Install Redis Server${RESET_COLOR}"
sudo apt-get install -y redis-server

echo -e "${MSG_COLOR}$(hostname): Configure Redis to listen on all interfaces${RESET_COLOR}"
sudo sed -i 's/^bind 127.0.0.1 ::1/bind 0.0.0.0/' /etc/redis/redis.conf

echo -e "${MSG_COLOR}$(hostname): Restart Redis${RESET_COLOR}"
sudo systemctl restart redis-server

echo -e "${MSG_COLOR}$(hostname): Finished!${RESET_COLOR}"
