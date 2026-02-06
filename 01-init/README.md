# Step 1: Initialization and Prerequisites

This step prepares your system for running Firecracker and Nomad.

## What this step does:
- Checks for root/sudo privileges.
- Verifies KVM virtualization support on the host.
- Installs `qemu-kvm` if necessary.
- Creates the `nomad` system user.
- Configures KVM permissions for the `nomad` user.
- Prepares base directories in `/opt/nomad` and `/opt/firecracker`.

## How to run:
```bash
sudo bash run.sh
```

## Prerequisites:
- Ubuntu 20.04+ or Debian 10+
- CPU with virtualization support (Intel VT-x or AMD-V)
