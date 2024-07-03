
LB_ID="$1"

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

echo "Load balancer ${WS_ID} registered in Consul."