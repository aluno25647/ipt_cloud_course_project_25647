#!/bin/bash

curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "websockets-server",
  "Name": "websockets-server",
  "Tags": ["web", "realtime"],
  "Address": "192.168.50.50",
  "Port": 8000,
  "Check": {
    "TCP": "192.168.50.50:8000",
    "Interval": "10s"
  }
}
EOF

echo "Websockets server service registered in Consul."
