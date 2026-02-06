#!/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "========================================"
echo "Step 5: Creating Sample Firecracker Job"
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

echo "Copying scripts and templates to /opt/firecracker..."
mkdir -p /opt/firecracker/scripts
mkdir -p /opt/firecracker/jobs
[ -d "$(dirname "$SCRIPT_DIR")/scripts" ] && cp -r "$(dirname "$SCRIPT_DIR")/scripts/"* /opt/firecracker/scripts/
[ -d "$SCRIPT_DIR/jobs" ] && cp -r "$SCRIPT_DIR/jobs/"* /opt/firecracker/jobs/
[ -f "$(dirname "$SCRIPT_DIR")/README.md" ] && cp "$(dirname "$SCRIPT_DIR")/README.md" /opt/firecracker/
[ -f "$(dirname "$SCRIPT_DIR")/QUICKSTART.md" ] && cp "$(dirname "$SCRIPT_DIR")/QUICKSTART.md" /opt/firecracker/
[ -f "$(dirname "$SCRIPT_DIR")/TROUBLESHOOTING.md" ] && cp "$(dirname "$SCRIPT_DIR")/TROUBLESHOOTING.md" /opt/firecracker/

echo "Setting proper permissions..."
chown -R nomad:nomad /opt/firecracker

echo ""
echo "✓ Sample job file created at /opt/firecracker/firecracker-job.nomad"
echo "To run it: nomad job run /opt/firecracker/firecracker-job.nomad"
echo ""
