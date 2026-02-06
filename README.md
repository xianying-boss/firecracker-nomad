# Firecracker + Nomad Cluster Infrastructure

This repository is organized similarly to the [e2b infra](https://github.com/e2b-dev/infra) repository, providing a modular approach to setting up Firecracker with Nomad.

## Project Structure

- **[init/](./init)**: Initial system setup and prerequisites.
- **[nomad-cluster-disk-image/](./nomad-cluster-disk-image)**: Scripts for installing binaries (Firecracker, Nomad, task driver).
- **[nomad-cluster/](./nomad-cluster)**: Cluster-level operations (starting Nomad, preparing images).
- **[nomad/](./nomad)**: Nomad job definitions and deployment scripts.

## Quick Start

Run the full installation:

```bash
sudo make all
```

Or run step-by-step:

```bash
sudo make init         # Step 1: Prereqs & Permissions
sudo make build-image  # Step 2: Install Binaries
sudo make apply        # Step 3: Start Services & Prepare Images
sudo make deploy-jobs  # Step 4: Deploy Sample Job
```

## Post-Installation: Root Filesystem

You need to provide a root filesystem image at `/opt/firecracker/images/rootfs.ext4`.

**Option A: Using Docker and Alpine Linux**
```bash
docker export $(docker create alpine) | dd of=/opt/firecracker/images/rootfs.ext4
```

**Option B: Download a pre-built rootfs**
```bash
wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/ubuntu-22.04.ext4 -O /opt/firecracker/images/rootfs.ext4
```

## Monitoring & Troubleshooting

Check the status of your cluster:

```bash
make status
```

Useful commands:
- `nomad node status`: Check node health.
- `journalctl -u nomad -f`: Follow Nomad logs.
- `nomad job status firecracker-example`: Check job status.

## Prerequisites

- Ubuntu 20.04+ or Debian 10+
- CPU with virtualization support (KVM)
- Root/sudo access
