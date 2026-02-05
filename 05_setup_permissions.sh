#!/bin/bash
set -e

echo "========================================"
echo "Step 5: Setting Up Permissions"
echo "========================================"

echo "Checking if nomad user exists..."
if id "nomad" &>/dev/null; then
    echo "✓ Nomad user exists"
else
    echo "Creating nomad user..."
    useradd -r -s /bin/false nomad
fi

echo "Adding nomad user to KVM group..."
usermod -aG kvm nomad

echo "Setting permissions for /dev/kvm..."
chmod 666 /dev/kvm

echo "Setting ownership for Nomad directories..."
chown -R nomad:nomad /opt/nomad

echo "Verifying permissions..."
ls -l /dev/kvm
groups nomad

echo ""
echo "✓ Permissions configured successfully!"
echo ""
