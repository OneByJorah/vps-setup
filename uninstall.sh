#!/bin/bash
read -p "Are you sure you want to uninstall Tailscale and WireGuard? [y/N]: " confirm
if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Aborting uninstallation."
    exit 0
fi

systemctl stop tailscaled wg-quick@wg0 2>/dev/null
systemctl disable tailscaled wg-quick@wg0 2>/dev/null
apt remove --purge -y tailscale wireguard wireguard-tools
rm -rf /etc/wireguard /var/lib/tailscale /var/log/tailscale-wireguard.log
ufw delete allow 41641/udp
ufw delete allow 51820/udp

echo "Tailscale and WireGuard have been removed. Built with ❤️ by JorahOne Services."
