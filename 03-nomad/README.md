# Step 3: Nomad Setup and Configuration

This step installs Nomad and the Firecracker task driver.

## What this step does:
- Adds the HashiCorp APT repository.
- Installs Nomad.
- Configures Nomad to use the Firecracker driver (via `/etc/nomad.d/nomad.hcl`).
- Downloads and installs the `firecracker-task-driver` plugin to `/opt/nomad/plugins`.
- Starts and enables the Nomad systemd service.

## How to run:
```bash
sudo bash run.sh
```

## Configuration:
The configuration file is located at `configs/nomad.hcl` and is copied to `/etc/nomad.d/nomad.hcl` during execution.
