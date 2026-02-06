# Step 4: Preparing Firecracker Images

Firecracker requires a Linux kernel and a root filesystem image to boot a MicroVM.

## What this step does:
- Creates `/opt/firecracker/images` directory.
- Attempts to download a compatible Linux kernel (`vmlinux.bin`).
- Sets appropriate ownership for the images directory.

## How to run:
```bash
sudo bash run.sh
```

## Manual Action Required:
You still need to provide a root filesystem image at `/opt/firecracker/images/rootfs.ext4`.
Example to download an Ubuntu-based rootfs:
```bash
wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/ubuntu-22.04.ext4 -O /opt/firecracker/images/rootfs.ext4
```
