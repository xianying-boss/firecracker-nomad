#!/bin/bash
set -e

echo "========================================"
echo "Step 2: Installing Nomad"
echo "========================================"

echo "Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

echo "Updating package list..."
apt-get update

echo "Installing Nomad..."
apt-get install -y nomad

echo "Verifying installation..."
nomad version

echo ""
echo "✓ Nomad installed successfully!"
echo ""
