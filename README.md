# Tailscale + WireGuard Setup

[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Shell Script](https://img.shields.io/badge/Bash-Automation-blue?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Status](https://img.shields.io/badge/Status-Stable-success)]()
[![Maintained by OneByJorah](https://img.shields.io/badge/Maintained%20by-OneByJorah-1E90FF?logo=github)](https://github.com/OneByJorah)

---

## Overview

Automated installer to set up **Tailscale + WireGuard** on Ubuntu 22.04 LTS VPS. Built with privacy, security, and simplicity in mind.

- ✅ Tailscale mesh VPN
- ✅ WireGuard lightweight VPN
- ✅ IP forwarding and firewall ready
- ✅ Logs installation and status

Built with ❤️ by **JorahOne Services – Secure Infrastructure Automation**

---

## Installation

### One-line Install:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/OneByJorah/tailscale-wireguard-setup/main/install.sh)"
```

### Manual Clone:
```bash
git clone https://github.com/OneByJorah/tailscale-wireguard-setup.git
cd tailscale-wireguard-setup
sudo bash install.sh
```

---

## Usage

### Commands:
```bash
sudo systemctl status tailscaled
sudo systemctl status wg-quick@wg0
sudo tailscale up --ssh
sudo wg show
```

### Logs:
```
/var/log/tailscale-wireguard.log
```

### Notes:
- Tailscale requires login: `tailscale up --ssh --accept-routes`
- Configure WireGuard peers in `/etc/wireguard/wg0.conf`

---

## Uninstallation
```bash
sudo bash uninstall.sh
```

---

## Requirements
- Ubuntu 22.04 LTS (64-bit)
- Root or sudo privileges
- Internet connection

---

## License
MIT License © 2025 [OneByJorah](https://github.com/OneByJorah)

---

## Contributing
Pull requests welcome! Open issues to discuss enhancements or fixes.
