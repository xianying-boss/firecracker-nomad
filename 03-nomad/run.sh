#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "========================================"
echo "Step 3: Setting up Nomad"
echo "========================================"

# 1. Install Nomad
echo "Installing Nomad..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && apt-get install -y nomad

# 2. Configure Nomad
echo "Configuring Nomad..."
mkdir -p /etc/nomad.d
mkdir -p /opt/nomad/data
cp "${SCRIPT_DIR}/configs/nomad.hcl" /etc/nomad.d/nomad.hcl
chmod 640 /etc/nomad.d/nomad.hcl

# 3. Install Firecracker Task Driver
echo "Installing Firecracker Task Driver..."
DRIVER_VERSION="v0.3.0"
mkdir -p /opt/nomad/plugins
curl -L https://github.com/cneira/firecracker-task-driver/releases/download/${DRIVER_VERSION}/firecracker-task-driver -o /opt/nomad/plugins/firecracker-task-driver
chmod +x /opt/nomad/plugins/firecracker-task-driver

# 4. Start Nomad
echo "Starting Nomad service..."
systemctl enable nomad
systemctl restart nomad

echo "Waiting for Nomad to start..."
sleep 5

echo "Verifying Nomad status..."
nomad node status

echo ""
echo "✓ Nomad setup complete!"
echo ""
