# Firecracker + Nomad Installation Scripts

This repository contains step-by-step shell scripts to install and configure Firecracker with Nomad on Ubuntu/Debian Linux.

## Prerequisites

- Ubuntu 20.04+ or Debian 10+ (64-bit)
- Root or sudo access
- CPU with virtualization support (Intel VT-x or AMD-V)
- At least 2GB RAM
- At least 10GB free disk space

## Quick Start

To install everything at once:

```bash
sudo bash install_all.sh
```

## Step-by-Step Installation

If you prefer to run each step individually:

### Step 0: Check Prerequisites
```bash
sudo bash 00_check_prerequisites.sh
```
Verifies KVM support and installs necessary packages.

### Step 1: Install Firecracker
```bash
sudo bash 01_install_firecracker.sh
```
Downloads and installs Firecracker v1.7.0.

### Step 2: Install Nomad
```bash
sudo bash 02_install_nomad.sh
```
Adds HashiCorp repository and installs Nomad.

### Step 3: Configure Nomad
```bash
sudo bash 03_configure_nomad.sh
```
Creates Nomad configuration file at `/etc/nomad.d/nomad.hcl`.

### Step 4: Install Firecracker Task Driver
```bash
sudo bash 04_install_task_driver.sh
```
Downloads and installs the Firecracker task driver plugin.

### Step 5: Setup Permissions
```bash
sudo bash 05_setup_permissions.sh
```
Configures user permissions and KVM access.

### Step 6: Prepare Firecracker Images
```bash
sudo bash 06_prepare_images.sh
```
Downloads kernel image and prepares directory structure.

### Step 7: Start Nomad Service
```bash
sudo bash 07_start_nomad.sh
```
Enables and starts the Nomad service.

### Step 8: Create Sample Job
```bash
sudo bash 08_create_sample_job.sh
```
Creates a sample Firecracker job definition.

### Step 9: Monitoring Commands
```bash
bash 09_monitoring_commands.sh
```
Displays useful monitoring and troubleshooting commands.

## Post-Installation Steps

### 1. Create a Root Filesystem

You need to provide a root filesystem image. Here are a few options:

**Option A: Using Docker and Alpine Linux**
```bash
docker export $(docker create alpine) | dd of=/opt/firecracker/images/rootfs.ext4
```

**Option B: Download a pre-built rootfs**
```bash
wget https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/x86_64/rootfs/bionic.rootfs.ext4 -O /opt/firecracker/images/rootfs.ext4
```

**Option C: Build with debootstrap**
```bash
# Install debootstrap
sudo apt-get install debootstrap

# Create rootfs
dd if=/dev/zero of=/opt/firecracker/images/rootfs.ext4 bs=1M count=1024
mkfs.ext4 /opt/firecracker/images/rootfs.ext4
mkdir -p /mnt/rootfs
mount /opt/firecracker/images/rootfs.ext4 /mnt/rootfs
debootstrap --arch amd64 focal /mnt/rootfs
umount /mnt/rootfs
```

### 2. Validate and Run the Sample Job

```bash
# Validate the job
nomad job validate /opt/firecracker/firecracker-job.nomad

# Run the job
nomad job run /opt/firecracker/firecracker-job.nomad

# Check job status
nomad job status firecracker-example
```

## Useful Commands

### Check Nomad Status
```bash
nomad node status
nomad server members
```

### View Logs
```bash
journalctl -u nomad -f
```

### Access Nomad UI
Open your browser and go to: http://localhost:4646

### Stop a Job
```bash
nomad job stop firecracker-example
```

### View Allocations
```bash
nomad alloc status <allocation-id>
```

## Directory Structure

```
/opt/firecracker/
├── images/
│   ├── vmlinux.bin          # Kernel image
│   └── rootfs.ext4          # Root filesystem (you need to create this)
└── firecracker-job.nomad    # Sample job file

/opt/nomad/
├── data/                    # Nomad data directory
└── plugins/                 # Nomad plugins
    └── firecracker-task-driver

/etc/nomad.d/
└── nomad.hcl               # Nomad configuration
```

## Troubleshooting

### Permission Denied on /dev/kvm
```bash
sudo chmod 666 /dev/kvm
sudo usermod -aG kvm nomad
```

### Nomad Service Won't Start
```bash
# Check logs
journalctl -u nomad -xe

# Verify configuration
nomad agent -config=/etc/nomad.d/nomad.hcl -dev
```

### Firecracker Driver Not Detected
```bash
# Check plugin
ls -l /opt/nomad/plugins/firecracker-task-driver

# Verify Nomad can see the plugin
nomad node status -self | grep firecracker
```

### Job Fails to Start
```bash
# Check allocation logs
nomad alloc logs <allocation-id>

# Check allocation status
nomad alloc status <allocation-id>
```

## Security Considerations

- These scripts are for development/testing purposes
- For production use:
  - Use proper authentication and ACLs
  - Secure the Nomad API with TLS
  - Implement proper network segmentation
  - Regular security updates
  - Use restricted permissions for /dev/kvm

## Additional Resources

- [Firecracker Documentation](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md)
- [Nomad Documentation](https://developer.hashicorp.com/nomad/docs)
- [Firecracker Task Driver](https://github.com/cneira/firecracker-task-driver)
- [Nomad Task Drivers](https://developer.hashicorp.com/nomad/docs/drivers)

## License

These scripts are provided as-is for educational and development purposes.

## Contributing

Feel free to submit issues or pull requests for improvements!
