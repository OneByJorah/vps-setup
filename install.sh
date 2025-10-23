#!/bin/bash

# =========================================================

# Tailscale + AdGuard Home Installer

# Author: OneByJorah

# Brand: JorahOne Services

# OS: Ubuntu 22.04 LTS

# Purpose: Secure network setup for VPS

# =========================================================

LOGFILE="/var/log/tailscale-adguard.log"

# Colors

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "$1" | tee -a $LOGFILE; }

echo -e "${GREEN}=== Updating system ===${NC}"
apt update && apt upgrade -y | tee -a $LOGFILE

log "${GREEN}=== Installing prerequisites ===${NC}"
apt install -y curl gnupg ufw apt-transport-https ca-certificates software-properties-common wget unzip | tee -a $LOGFILE

log "${GREEN}=== Installing Tailscale ===${NC}"
curl -fsSL [https://tailscale.com/install.sh](https://tailscale.com/install.sh) | sh | tee -a $LOGFILE
systemctl enable --now tailscaled | tee -a $LOGFILE

log "${YELLOW}=== Please log in to Tailscale ===${NC}"
echo "Run: tailscale up --ssh --accept-routes"
log "Tailscale setup pending authentication"

log "${GREEN}=== Installing AdGuard Home ===${NC}"
AG_VERSION=$(curl -s [https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest](https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest) | grep 'tag_name' | cut -d" -f4)
wget [https://github.com/AdguardTeam/AdGuardHome/releases/download/${AG_VERSION}/AdGuardHome_linux_amd64.tar.gz](https://github.com/AdguardTeam/AdGuardHome/releases/download/${AG_VERSION}/AdGuardHome_linux_amd64.tar.gz) -O /tmp/AdGuardHome.tar.gz
mkdir -p /opt/AdGuardHome
tar -xzf /tmp/AdGuardHome.tar.gz -C /opt/AdGuardHome --strip-components=1
/opt/AdGuardHome/AdGuardHome -s install | tee -a $LOGFILE
systemctl enable --now AdGuardHome

log "${GREEN}=== Configuring UFW firewall ===${NC}"
ufw allow 22/tcp comment 'SSH'
ufw allow 41641/udp comment 'Tailscale'
ufw allow 53/tcp comment 'DNS'
ufw allow 53/udp comment 'DNS'
ufw allow 3000/tcp comment 'AdGuard Web'
ufw --force enable | tee -a $LOGFILE

log "${GREEN}=== Installation complete! ===${NC}"
echo "Built with ❤️ by JorahOne Services – Secure Infrastructure Automation"
echo "Check logs at $LOGFILE"
echo "Use 'tailscale up' to authenticate and configure Tailscale"
echo "AdGuard Home web interface: http://<VPS_IP>:3000"
