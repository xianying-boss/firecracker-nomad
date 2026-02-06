#!/bin/bash
set -e

echo "========================================"
echo "Step 1: Initializing and Checking Prerequisites"
echo "========================================"

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo or as root"
    exit 1
fi

# Check if KVM is available
echo "Checking KVM support..."
if lsmod | grep -q kvm; then
    echo "✓ KVM module is loaded"
else
    echo "✗ KVM module not found"
    echo "Installing KVM..."
    apt-get update
    apt-get install -y qemu-kvm
fi

# Verify KVM device exists
if [ -e /dev/kvm ]; then
    echo "✓ /dev/kvm exists"
else
    echo "✗ /dev/kvm not found. Your system may not support virtualization."
    exit 1
fi

# Check CPU virtualization support
if grep -E 'vmx|svm' /proc/cpuinfo > /dev/null; then
    echo "✓ CPU supports virtualization"
else
    echo "✗ CPU does not support virtualization"
    exit 1
fi

echo "Setting up permissions..."
echo "Checking if nomad user exists..."
if id "nomad" &>/dev/null; then
    echo "✓ Nomad user exists"
else
    echo "Creating nomad user..."
    useradd -r -s /bin/false nomad
fi

echo "Adding nomad user to KVM group..."
usermod -aG kvm nomad

echo "Setting permissions for /dev/kvm..."
chmod 666 /dev/kvm

echo "Setting ownership for Nomad and Firecracker directories..."
mkdir -p /opt/nomad
mkdir -p /opt/firecracker
chown -R nomad:nomad /opt/nomad
chown -R nomad:nomad /opt/firecracker

echo ""
echo "✓ Initialization and prerequisites check complete!"
echo ""
