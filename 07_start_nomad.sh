#!/bin/bash
set -e

echo "========================================"
echo "Step 7: Starting Nomad Service"
echo "========================================"

echo "Enabling Nomad service..."
systemctl enable nomad

echo "Starting Nomad service..."
systemctl start nomad

echo "Waiting for Nomad to start..."
sleep 5

echo "Checking Nomad status..."
systemctl status nomad --no-pager

echo ""
echo "Verifying Nomad cluster..."
nomad node status
nomad server members

echo ""
echo "✓ Nomad service started successfully!"
echo ""
echo "You can check logs with: journalctl -u nomad -f"
echo ""
