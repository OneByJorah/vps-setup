AdGuard + Tailscale + WireGuard Setup Script

A simple, secure, and automated installer that turns any Ubuntu 22.04 VPS into a private DNS + VPN hub, accessible only through Tailscale.

🧩 Overview

This script automatically installs and configures:

Tailscale → private networking and secure remote access

WireGuard → fast VPN service

AdGuard Home → DNS-level ad blocking and filtering

UFW → firewall with strict rules allowing only SSH, Tailscale, and WireGuard

All services are bound to your Tailscale IP for maximum privacy.

⚙️ Installation

Run this one-line installer as root or with sudo:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/OneByJorah/vps-setup/main/adguard-tailscale-wireguard.sh)"

🚀 What Happens

Updates your system

Installs all dependencies

Installs and enables Tailscale, WireGuard, and AdGuard Home

Prompts you to log into Tailscale

Binds AdGuard Home to your Tailscale IP

Configures UFW firewall to secure your server

🧠 Post-Install Setup
🔹 Access AdGuard Home

After installation, from another Tailscale-connected device, open:

http://<tailscale-ip>:3000


Follow the on-screen wizard to finish setup manually.

🔹 Configure WireGuard

The installer enables WireGuard but leaves configuration up to you.
Edit /etc/wireguard/wg0.conf to add peers and keys.

Example:

[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32


Start it:

sudo systemctl enable --now wg-quick@wg0

🔹 Firewall Rules (UFW)

SSH → TCP 22

Tailscale → UDP 41641

WireGuard → UDP 51820

🧾 Useful Commands
Task	Command
Check Tailscale status	tailscale status
Get Tailscale IP	tailscale ip -4
Restart AdGuard Home	sudo systemctl restart AdGuardHome
View WireGuard interface	sudo wg show
Edit WireGuard config	sudo nano /etc/wireguard/wg0.conf
Reboot server	sudo reboot
🛡️ Security Tips

Keep your VPS updated: sudo apt update && sudo apt upgrade -y

Avoid exposing AdGuard Home publicly

Manage DNS and VPN only through Tailscale for maximum security

Use strong WireGuard keys and avoid reusing them across devices

📚 System Requirements

Ubuntu 22.04 LTS (x86_64)

Minimum 512 MB RAM

Root or sudo privileges

Internet access for installation

✨ Author

Created by OneByJorah
A project focused on secure, simple, and self-hosted infrastructure setups.
