#!/bin/bash

# Check if LB_ID parameter is provided
if [ -z "$1" ]; then
    echo -e "\033[0;31mError: LB_ID parameter is missing.\033[0m"
    echo "Usage: $0 <LB_ID>"
    exit 1
fi

LB_ID="$1"

# Color variables
MSG_COLOR="\033[0;32m"    # Green color for messages
RESET_COLOR="\033[0m"     # Reset color

# Register load balancer service in Consul
echo -e "${MSG_COLOR}Registering load balancer ${LB_ID} in Consul...${RESET_COLOR}"
curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "lb-${LB_ID}",
  "Name": "load-balancer",
  "Tags": ["nginx", "keepalived"],
  "Address": "192.168.50.${LB_ID}0",
  "Port": 80,
  "Check": {
    "HTTP": "http://192.168.50.${LB_ID}0/",
    "Interval": "10s"
  }
}
EOF

echo -e "${MSG_COLOR}Load balancer ${LB_ID} registered in Consul.${RESET_COLOR}"
