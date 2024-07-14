#!/bin/bash

# Color variables
MSG_COLOR="\033[0;35m"    # Purple color for messages
RESET_COLOR="\033[0m"     # Reset color

# Extract WS_ID from command-line argument
WS_ID="$1"

# Calculate IP address
IP_ADDR=$((WS_ID + 10))

# Register web-server service in Consul
echo -e "${MSG_COLOR}Registering web-server service web-${WS_ID} in Consul...${RESET_COLOR}"
curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "web-${WS_ID}",
  "Name": "web-server",
  "Tags": ["apache", "php"],
  "Address": "192.168.44.${IP_ADDR}",
  "Port": 80,
  "Check": {
    "HTTP": "http://192.168.44.${IP_ADDR}/",
    "Interval": "10s"
  }
}
EOF

echo -e "${MSG_COLOR}Web server service web-${WS_ID} registered in Consul.${RESET_COLOR}"
