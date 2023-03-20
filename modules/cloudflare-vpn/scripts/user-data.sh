#!/bin/bash

set -x 

set -e 

sudo apt update && sudo apt install wget

wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

sudo dpkg -i cloudflared-linux-amd64.deb

sudo mkdir ~/.cloudflared
sudo touch ~/.cloudflared/cert.json
sudo touch ~/.cloudflared/config.yml

sudo cat > ~/.cloudflared/cert.json << "EOF"
{
    "AccountTag"   : "${account}",
    "TunnelID"     : "${tunnel_id}",
    "TunnelName"   : "${tunnel_name}",
    "TunnelSecret" : "${secret}"
}
EOF

sudo cat > ~/.cloudflared/config.yml << "EOF"
tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/cert.json
logfile: /var/log/cloudflared.log
loglevel: info 
EOF

sudo cp -via ~/.cloudflared/cert.json /etc/cloudflared/
sudo cloudflared service install
