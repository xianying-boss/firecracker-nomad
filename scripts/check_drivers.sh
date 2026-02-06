#!/bin/bash

echo "========================================"
echo "Nomad Firecracker Driver Diagnostics"
echo "========================================"
echo ""

echo "1. Checking Nomad service status..."
systemctl status nomad --no-pager | head -20
echo ""

echo "2. Checking Nomad node status..."
nomad node status
echo ""

echo "3. Checking available drivers..."
nomad node status -self -verbose | grep -A 20 "Driver Status"
echo ""

echo "4. Checking for firecracker driver..."
if nomad node status -self -verbose | grep -i firecracker; then
    echo "✓ Firecracker driver detected"
else
    echo "✗ Firecracker driver NOT detected"
fi
echo ""

echo "5. Checking plugin directory..."
ls -lh /opt/nomad/plugins/
echo ""

echo "6. Checking firecracker binary..."
which firecracker
firecracker --version
echo ""

echo "7. Checking Nomad logs for errors..."
echo "Last 20 lines of Nomad logs:"
journalctl -u nomad -n 20 --no-pager
echo ""

echo "8. Checking datacenter..."
nomad server members
echo ""

echo "9. Checking if raw_exec driver is enabled..."
if nomad node status -self -verbose | grep -i "raw_exec"; then
    echo "✓ raw_exec driver detected"
else
    echo "✗ raw_exec driver NOT detected"
fi
echo ""

echo "10. Listing all available job drivers..."
nomad node status -self -json | jq '.Drivers'
echo ""

echo "========================================"
echo "Diagnostic complete!"
echo "========================================"
echo ""
echo "If firecracker driver is not detected, try:"
echo "1. Check if plugin exists: ls -l /opt/nomad/plugins/firecracker-task-driver"
echo "2. Restart Nomad: sudo systemctl restart nomad"
echo "3. Check Nomad config: cat /etc/nomad.d/nomad.hcl"
echo "4. Try running with raw_exec driver instead"
echo ""
