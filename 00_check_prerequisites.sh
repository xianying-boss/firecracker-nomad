#!/bin/bash
set -e

echo "========================================"
echo "Step 0: Checking Prerequisites"
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

echo ""
echo "Prerequisites check complete!"
echo ""
