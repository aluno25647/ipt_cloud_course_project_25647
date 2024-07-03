#!/bin/bash

WS_ID="$1"

IP_ADDR=$((WS_ID + 10))

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

echo "Web server service web-${WS_ID} registered in Consul."
