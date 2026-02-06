# Firecracker + Nomad Step-by-Step Installation

This repository provides a modular, step-by-step guide to installing and configuring Firecracker with Nomad on Ubuntu/Debian.

## Structure

The installation is divided into logical steps:

1.  **[01-init](./01-init)**: Prerequisites check and system initialization.
2.  **[02-firecracker](./02-firecracker)**: Firecracker binary installation.
3.  **[03-nomad](./03-nomad)**: Nomad installation and configuration with Firecracker driver.
4.  **[04-images](./04-images)**: Kernel and rootfs image preparation.
5.  **[05-jobs](./05-jobs)**: Sample job creation and deployment.

## Quick Start

You can run the entire installation using the provided `Makefile`:

```bash
sudo make all
```

Or run individual steps:

```bash
sudo make init
sudo make firecracker
sudo make nomad
sudo make images
sudo make jobs
```

## Monitoring

To see useful monitoring commands:

```bash
make status
```

## Manual Installation

If you prefer to run scripts manually, navigate to each directory and follow the instructions in its `README.md`.

## Prerequisites

- Ubuntu 20.04+ or Debian 10+
- CPU with virtualization support (KVM)
- Root/sudo access

## Additional Resources

- [Firecracker Documentation](https://github.com/firecracker-microvm/firecracker)
- [Nomad Documentation](https://developer.hashicorp.com/nomad)
- [Firecracker Task Driver](https://github.com/cneira/firecracker-task-driver)
