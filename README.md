# Project A

Mestrado em Engenharia Informática – IoT

Computação em Nuvem e Virtualização - 2023/2024

Luís Costa – n.º 25647 /
Paulo Peixoto – n.º 26097 /
Ricardo Elisiário – n.º 26534


## Descrição

Este projeto é uma aplicação web escalável e resiliente, implementada utilizando várias tecnologias para garantir alta disponibilidade, desempenho e monitorização eficaz. A arquitetura inclui balanceamento de carga, servidores web redundantes, armazenamento distribuído e monitorização em tempo real.

## Arquitetura

### Componentes Principais

- **Consul**: Serviço de descoberta e configuração distribuída.
- **Nginx**: Balanceador de carga.
- **Servidores Web (Apache + PHP)**: Servidores responsáveis por servir a aplicação web.
- **Redis**: Armazenamento de sessões.
- **GlusterFS**: Sistema de ficheiros distribuído para armazenamento de imagens.
- **PostgreSQL**: Base de dados relacional.
- **Prometheus**: Sistema de monitorização e alerta.
- **Grafana**: Painel de visualização para dados de monitorização.

## Instalação e Configuração

### Pré-requisitos

- Vagrant
- VirtualBox

### Passos para Configuração

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/project-a.git
   cd project-a

2. Inicie as VMs com Vagrant:
   ```bash
   vagrant up

3. Aceda à aplicação web através do IP configurado no balanceador de carga (http://192.168.50.100).

4. Para aceder a outras funcionalidades:

   ```bash
    [Consul]
    http://192.168.50.200:8500

    [Prometheus]
    http://192.168.50.60:9090/targets

    [Grafana]
    http://192.168.50.70:3000
