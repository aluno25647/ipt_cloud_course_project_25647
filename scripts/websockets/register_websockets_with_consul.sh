#!/bin/bash

# Definindo cores para mensagens
MSG_COLOR="\033[41m"  # Cor de fundo vermelha para mensagens
NC="\033[0m"          # Resetar formatação de cor

# Mensagem informando que o serviço está sendo registrado
echo -e "${MSG_COLOR}$(hostname): Registrando o serviço de websockets no Consul${NC}"

# Envia uma requisição PUT com dados para registrar o serviço no Consul
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

# Mensagem indicando que o serviço de websockets foi registrado no Consul
echo -e "${MSG_COLOR}$(hostname): Serviço de websockets registrado no Consul.${NC}"
