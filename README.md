🛰️ AdGuard + Tailscale + WireGuard Automated VPS Setup

Author: OneByJorah

OS Target: Ubuntu 22.04 LTS
Category: Network Security / Self-Hosting / VPN Automation

🔧 Overview

A fully automated, production-grade installer designed to transform any Ubuntu VPS into a secure, private DNS + VPN gateway, powered by:

🧩 AdGuard Home — Ad-blocking DNS resolver

🔐 Tailscale — Zero-config secure network overlay

⚡ WireGuard — High-speed, lightweight VPN tunnel

🛡️ UFW Firewall — Hardened perimeter protection

This stack is ideal for personal, family, or team networks who value privacy-first architecture and no-cloud dependency.

🧠 Core Features
Feature	Description
🧩 AdGuard Home	Local DNS filtering and ad blocking, running on your Tailscale IP only.
🔐 Tailscale Integration	Instantly access your VPS via encrypted Tailscale tunnel — no port forwarding required.
⚡ WireGuard Ready	WireGuard preinstalled and systemd-enabled; add clients in seconds.
🛡️ Firewall Protection	Preconfigured UFW rules allowing only SSH, WireGuard, and Tailscale traffic.
🔄 Autostart Services	Tailscale, AdGuard, and WireGuard automatically restart on reboot.
🧰 Minimal Dependencies	Clean install, zero bloat, fully scriptable infrastructure.
🚀 Installation

Run this one-line command on a fresh Ubuntu 22.04 VPS:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/OneByJorah/vps-setup/main/adguard-tailscale-wireguard.sh)"


The script will:

Update your system packages

Install Tailscale, WireGuard, and AdGuard Home

Prompt you to authenticate Tailscale

Bind AdGuard to your private Tailscale IP

Enable firewall and start all services

🧩 Network Architecture Diagram
                ┌────────────────────────────┐
                │        Internet            │
                └────────────┬───────────────┘
                             │
                      (Encrypted Tunnel)
                             │
                  ┌────────────────────┐
                  │     VPS Server     │
                  │ Ubuntu 22.04 LTS   │
                  │                    │
                  │  ┌──────────────┐  │
                  │  │  Tailscale   │◄─┼─ Remote Devices
                  │  └──────────────┘  │
                  │  ┌──────────────┐  │
                  │  │ WireGuard VPN│◄─┼─ Manual Clients
                  │  └──────────────┘  │
                  │  ┌──────────────┐  │
                  │  │ AdGuard Home │  │
                  │  │ (DNS Filter) │  │
                  │  └──────────────┘  │
                  └────────────────────┘

⚙️ Configuration Details
🧱 Firewall (UFW Rules)
Port	Protocol	Service	Purpose
22	TCP	SSH	Secure management access
41641	UDP	Tailscale	Peer connectivity
51820	UDP	WireGuard	VPN tunnel
🧩 AdGuard Home Access

Accessible only through your Tailscale network.
From any Tailscale-connected device, open:

http://<Tailscale-IP>:3000


You’ll complete the AdGuard setup manually (choose your DNS upstreams and filters).

🔧 WireGuard Configuration Example

/etc/wireguard/wg0.conf

[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32


Start it:

sudo systemctl enable --now wg-quick@wg0

🧰 Testing & Validation

Run the following to validate your setup:

# Verify Tailscale connection
tailscale status

# Check AdGuard Home service
sudo systemctl status AdGuardHome

# Test DNS resolution through AdGuard
dig @$(tailscale ip -4 | head -n1) google.com

# Check WireGuard interface
sudo wg show


✅ Expected Results

All services show active (running)

DNS queries resolve via AdGuard

WireGuard interface (wg0) is up and listening on UDP 51820

🛡️ Security Best Practices

Disable password SSH login: sudo nano /etc/ssh/sshd_config → PasswordAuthentication no

Keep system updated: sudo apt update && sudo apt upgrade -y

Use Tailscale ACLs to limit access between devices

Store your WireGuard keys securely

🧾 Troubleshooting
Issue	Fix
Tailscale not starting	sudo systemctl restart tailscaled
AdGuard not reachable	Ensure you’re on Tailscale and use tailscale ip -4
WireGuard interface down	sudo systemctl enable --now wg-quick@wg0
DNS not resolving	Verify AdGuard “Listening IP” matches your Tailscale IP
📚 System Requirements
Resource	Minimum
OS	Ubuntu 22.04 LTS
CPU	1 Core
RAM	512 MB
Disk	2 GB
Network	Public IPv4 with outbound internet
🧑‍💻 Author & Credits

Created by: OneByJorah

Focus: Secure, lightweight, and self-managed infrastructure automation
License: MIT
Version: v1.0.0

"Privacy and simplicity can coexist — automate your security stack and own your network."
