#!/bin/bash
set -e

echo "========================================"
echo "Step 6: Preparing Firecracker Images"
echo "========================================"

echo "Creating directory for Firecracker artifacts..."
mkdir -p /opt/firecracker/images

echo "Downloading sample kernel..."
wget https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/x86_64/kernels/vmlinux.bin -O /opt/firecracker/images/vmlinux.bin

echo "Kernel downloaded successfully"

echo ""
echo "Note: You need to provide a root filesystem (rootfs.ext4)"
echo "You can:"
echo "  1. Build your own using tools like buildroot or debootstrap"
echo "  2. Download a pre-built image"
echo "  3. Create one from Alpine Linux or Ubuntu"
echo ""
echo "Example to create a simple Alpine rootfs:"
echo "  docker export \$(docker create alpine) | dd of=/opt/firecracker/images/rootfs.ext4"
echo ""

echo "Setting proper permissions..."
chown -R nomad:nomad /opt/firecracker

echo ""
echo "✓ Firecracker images directory prepared!"
echo ""
