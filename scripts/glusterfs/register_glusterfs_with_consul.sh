#!/bin/bash

curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "glusterfs",
  "Name": "glusterfs",
  "Tags": ["storage"],
  "Address": "192.168.50.40",
  "Port": 24007,
  "Check": {
    "TCP": "192.168.50.40:24007",
    "Interval": "10s",
    "Timeout": "1s"
  }
}
EOF

echo "GlusterFS service registered in Consul."
