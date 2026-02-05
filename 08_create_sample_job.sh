#!/bin/bash
set -e

echo "========================================"
echo "Step 8: Creating Sample Firecracker Job"
echo "========================================"

echo "Creating sample job file..."
cat > /opt/firecracker/firecracker-job.nomad <<'EOF'
job "firecracker-example" {
  datacenters = ["dc1"]
  type = "service"

  group "microvm" {
    count = 1

    task "vm" {
      driver = "firecracker"

      config {
        KernelImage = "/opt/firecracker/images/vmlinux.bin"
        RootDrive = "/opt/firecracker/images/rootfs.ext4"
        
        Vcpus = 1
        Mem = 128
        
        Network {
          device = "eth0"
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
EOF

echo "Setting proper permissions..."
chown nomad:nomad /opt/firecracker/firecracker-job.nomad

echo ""
echo "✓ Sample job file created at /opt/firecracker/firecracker-job.nomad"
echo ""
echo "To validate the job, run:"
echo "  nomad job validate /opt/firecracker/firecracker-job.nomad"
echo ""
echo "To run the job, run:"
echo "  nomad job run /opt/firecracker/firecracker-job.nomad"
echo ""
