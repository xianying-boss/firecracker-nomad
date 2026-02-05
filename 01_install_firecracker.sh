#!/bin/bash
set -e

echo "========================================"
echo "Step 1: Installing Firecracker"
echo "========================================"

# Set version (you can change this)
FIRECRACKER_VERSION="v1.7.0"

echo "Downloading Firecracker ${FIRECRACKER_VERSION}..."
cd /tmp
curl -LOJ https://github.com/firecracker-microvm/firecracker/releases/download/${FIRECRACKER_VERSION}/firecracker-${FIRECRACKER_VERSION}-x86_64.tgz

echo "Extracting Firecracker..."
tar -xzf firecracker-${FIRECRACKER_VERSION}-x86_64.tgz

echo "Installing Firecracker binary..."
mv release-${FIRECRACKER_VERSION}-x86_64/firecracker-${FIRECRACKER_VERSION}-x86_64 /usr/local/bin/firecracker
chmod +x /usr/local/bin/firecracker

echo "Cleaning up..."
rm -rf firecracker-${FIRECRACKER_VERSION}-x86_64.tgz release-${FIRECRACKER_VERSION}-x86_64

echo "Verifying installation..."
firecracker --version

echo ""
echo "✓ Firecracker installed successfully!"
echo ""
