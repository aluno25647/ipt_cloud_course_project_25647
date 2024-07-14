#!/bin/bash

# Color variables
MSG_COLOR="\033[0;32m"    # Green color for messages
RESET_COLOR="\033[0m"     # Reset color

# Register sessions-server service in Consul
echo -e "${MSG_COLOR}Registering sessions-server service in Consul...${RESET_COLOR}"
curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "sessions-server",
  "Name": "sessions-server",
  "Tags": ["database", "cache"],
  "Address": "192.168.50.30",
  "Port": 6379,
  "Check": {
    "TCP": "192.168.50.30:6379",
    "Interval": "10s"
  }
}
EOF

echo -e "${MSG_COLOR}Sessions server service registered in Consul.${RESET_COLOR}"
