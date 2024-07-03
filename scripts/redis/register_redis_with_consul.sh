#!/bin/bash

curl --request PUT --data @- http://192.168.50.200:8500/v1/agent/service/register <<EOF
{
  "ID": "redis-${REDIS_ID}",
  "Name": "redis",
  "Tags": ["database", "cache"],
  "Address": "192.168.44.10",
  "Port": 6379,
  "Check": {
    "TCP": "192.168.44.10:6379",
    "Interval": "10s"
  }
}
EOF

echo "Redis service registered in Consul."
