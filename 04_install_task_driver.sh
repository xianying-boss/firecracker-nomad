#!/bin/bash
set -e

echo "========================================"
echo "Step 4: Installing Firecracker Task Driver"
echo "========================================"

# Set version
DRIVER_VERSION="v0.3.0"

echo "Creating plugin directory..."
mkdir -p /opt/nomad/plugins

echo "Downloading Firecracker task driver ${DRIVER_VERSION}..."
curl -L https://github.com/cneira/firecracker-task-driver/releases/download/${DRIVER_VERSION}/firecracker-task-driver -o /tmp/firecracker-task-driver

echo "Installing task driver..."
mv /tmp/firecracker-task-driver /opt/nomad/plugins/
chmod +x /opt/nomad/plugins/firecracker-task-driver

echo "Verifying installation..."
ls -lh /opt/nomad/plugins/firecracker-task-driver

echo ""
echo "✓ Firecracker task driver installed successfully!"
echo ""
