#!/bin/bash
set -e

echo "========================================"
echo "Step 3: Configuring Nomad"
echo "========================================"

echo "Creating Nomad configuration directory..."
mkdir -p /etc/nomad.d
mkdir -p /opt/nomad/data

echo "Creating Nomad configuration file..."
cat > /etc/nomad.d/nomad.hcl <<'EOF'
data_dir = "/opt/nomad/data"
plugin_dir = "/opt/nomad/plugins"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  
  options {
    "driver.firecracker.enable" = "1"
  }
}

plugin "firecracker" {
  config {
    # Path to firecracker binary
    firecracker_binary = "/usr/local/bin/firecracker"
    
    # Enable kernel overcommit (if needed)
    disable_overcommit = false
  }
}
EOF

echo "Setting proper permissions..."
chmod 640 /etc/nomad.d/nomad.hcl

echo ""
echo "✓ Nomad configuration created at /etc/nomad.d/nomad.hcl"
echo ""
