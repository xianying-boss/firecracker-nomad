#!/bin/bash
set -e

echo "========================================"
echo "Step 6: Preparing Firecracker Images"
echo "========================================"

echo "Creating directory for Firecracker artifacts..."
mkdir -p /opt/firecracker/images

echo "Downloading sample kernel..."
echo "Trying primary source..."

# Try multiple sources for the kernel
if wget -q --spider https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/vmlinux-5.10.bin 2>/dev/null; then
    wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/vmlinux-5.10.bin -O /opt/firecracker/images/vmlinux.bin
    echo "Kernel downloaded successfully from GitHub"
elif wget -q --spider https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/x86_64/vmlinux-5.10.bin 2>/dev/null; then
    wget https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.7/x86_64/vmlinux-5.10.bin -O /opt/firecracker/images/vmlinux.bin
    echo "Kernel downloaded successfully from S3"
else
    echo "Warning: Could not download kernel automatically"
    echo "Please manually download a compatible Linux kernel and place it at:"
    echo "  /opt/firecracker/images/vmlinux.bin"
    echo ""
    echo "You can get kernels from:"
    echo "  1. https://github.com/firecracker-microvm/firecracker/releases"
    echo "  2. Build your own using: https://github.com/firecracker-microvm/firecracker/blob/main/docs/rootfs-and-kernel-setup.md"
    echo ""
fi

echo ""
echo "Note: You need to provide a root filesystem (rootfs.ext4)"
echo "You can:"
echo "  1. Download from: https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/ubuntu-22.04.ext4"
echo "  2. Build your own using tools like buildroot or debootstrap"
echo "  3. Create one from Alpine Linux or Ubuntu"
echo ""
echo "Example to download Ubuntu rootfs:"
echo "  wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/ubuntu-22.04.ext4 -O /opt/firecracker/images/rootfs.ext4"
echo ""
echo "Example to create a simple Alpine rootfs:"
echo "  docker export \$(docker create alpine) | dd of=/opt/firecracker/images/rootfs.ext4"
echo ""

echo "Setting proper permissions..."
chown -R nomad:nomad /opt/firecracker

echo ""
echo "✓ Firecracker images directory prepared!"
echo ""
