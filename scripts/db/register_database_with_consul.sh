#!/bin/bash

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

echo "Database server service registered in Consul."
