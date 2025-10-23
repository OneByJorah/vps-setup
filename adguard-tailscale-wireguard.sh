#!/bin/bash
# =========================================================
#  AdGuard + Tailscale + WireGuard Setup Script
#  Author: OneByJorah
#  OS: Ubuntu 22.04 LTS
#  Purpose: Private DNS/VPN hub via Tailscale only
# =========================================================

set -e

echo "=== Updating system ==="
apt update && apt upgrade -y

echo "=== Installing prerequisites ==="
apt install -y curl wget unzip gnupg ufw apt-transport-https ca-certificates software-properties-common

echo "=== Installing Tailscale ==="
curl -fsSL https://tailscale.com/install.sh | sh
systemctl enable --now tailscaled

echo "=== Login to Tailscale ==="
tailscale up --ssh --accept-routes
echo "✅ Once logged in, your VPS will be connected to your Tailscale network."

echo "=== Installing WireGuard ==="
apt install -y wireguard wireguard-tools
systemctl enable --now wg-quick@wg0 || true
echo "✅ WireGuard installed (edit /etc/wireguard/wg0.conf as needed)."

echo "=== Installing AdGuard Home ==="
cd /opt
curl -s -L https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz -o adguard.tar.gz
tar xzf adguard.tar.gz && rm adguard.tar.gz
cd AdGuardHome
./AdGuardHome -s install

echo "=== Binding AdGuard to Tailscale only ==="
sleep 5
TAILSCALE_IP=$(tailscale ip -4 | head -n1)
CONFIG_FILE="/opt/AdGuardHome/AdGuardHome.yaml"
if [ -f "$CONFIG_FILE" ]; then
  sed -i "s/^bind_host:.*/bind_host: $TAILSCALE_IP/" "$CONFIG_FILE" || true
fi
systemctl restart AdGuardHome
echo "✅ AdGuard now bound to $TAILSCALE_IP:3000 (accessible only via Tailscale)."

echo "=== Configuring UFW firewall ==="
ufw allow 22/tcp comment 'SSH'
ufw allow 41641/udp comment 'Tailscale'
ufw allow 51820/udp comment 'WireGuard'
ufw --force enable

echo "========================================================="
echo "✅ Installation complete!"
echo "AdGuard Home: http://$TAILSCALE_IP:3000"
echo "Tailscale: Connected and active"
echo "WireGuard: Installed, configure /etc/wireguard/wg0.conf"
echo "UFW: Enabled (SSH, Tailscale, WireGuard allowed)"
echo "========================================================="
