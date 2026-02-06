#!/bin/bash
set -e

echo "========================================"
echo "Step 4: Preparing Firecracker Images"
echo "========================================"

echo "Creating directory for Firecracker artifacts..."
mkdir -p /opt/firecracker/images

echo "Downloading sample kernel..."
# Try multiple sources for the kernel
if wget -q --spider https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/vmlinux-5.10.bin 2>/dev/null; then
    wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/vmlinux-5.10.bin -O /opt/firecracker/images/vmlinux.bin
    echo "Kernel downloaded successfully from GitHub"
elif wget -q --spider https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/x86_64/vmlinux-5.10.bin 2>/dev/null; then
    wget https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/x86_64/vmlinux-5.10.bin -O /opt/firecracker/images/vmlinux.bin
    echo "Kernel downloaded successfully from S3"
else
    echo "Warning: Could not download kernel automatically. Please provide it at /opt/firecracker/images/vmlinux.bin"
fi

echo "Setting proper permissions..."
chown -R nomad:nomad /opt/firecracker

echo ""
echo "Note: You still need to provide a root filesystem (rootfs.ext4) at /opt/firecracker/images/rootfs.ext4"
echo ""
echo "✓ Firecracker images directory prepared!"
echo ""
