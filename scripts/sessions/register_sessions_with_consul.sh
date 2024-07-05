#!/bin/bash

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

echo "Sessions server service registered in Consul."
