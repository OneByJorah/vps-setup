#!/bin/bash
LOGFILE="/var/log/tailscale-wireguard.log"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "$1" | tee -a $LOGFILE; }

echo -e "${GREEN}=== Updating system ===${NC}"
apt update && apt upgrade -y | tee -a $LOGFILE

log "${GREEN}=== Installing prerequisites ===${NC}"
apt install -y curl gnupg ufw apt-transport-https ca-certificates software-properties-common | tee -a $LOGFILE

log "${GREEN}=== Installing Tailscale ===${NC}"
curl -fsSL https://tailscale.com/install.sh | sh | tee -a $LOGFILE
systemctl enable --now tailscaled | tee -a $LOGFILE

log "${YELLOW}=== Please log in to Tailscale ===${NC}"
echo "Run: tailscale up --ssh --accept-routes"
log "Tailscale setup pending authentication"

log "${GREEN}=== Installing WireGuard ===${NC}"
apt install -y wireguard wireguard-tools | tee -a $LOGFILE
systemctl enable wg-quick@wg0 2>/dev/null || true

log "${GREEN}=== Enabling IP forwarding ===${NC}"
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p | tee -a $LOGFILE

log "${GREEN}=== Configuring UFW firewall ===${NC}"
ufw allow 22/tcp comment 'SSH'
ufw allow 41641/udp comment 'Tailscale'
ufw allow 51820/udp comment 'WireGuard'
ufw --force enable | tee -a $LOGFILE

log "${GREEN}=== Installation complete! ===${NC}"
echo "Built with ❤️ by JorahOne Services – Secure Infrastructure Automation"
echo "Check logs at $LOGFILE"
echo "Use 'tailscale up' to authenticate and configure Tailscale"
echo "Edit /etc/wireguard/wg0.conf to configure WireGuard peers"
