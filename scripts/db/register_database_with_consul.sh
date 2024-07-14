#!/bin/bash

# Color variables
MSG_COLOR="\033[0;36m"  # Cyan color for messages
RESET_COLOR="\033[0m"   # Reset color

curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "database-server",
  "Name": "database-server",
  "Tags": ["database", "postgresql"],
  "Address": "192.168.50.80",
  "Port": 5432,
  "Check": {
    "TCP": "192.168.50.80:5432",
    "Interval": "10s"
  }
}
EOF

echo -e "${MSG_COLOR}Database server service registered in Consul.${RESET_COLOR}"
