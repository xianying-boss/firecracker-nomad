#!/bin/bash
set -e

echo "========================================"
echo "Starting Nomad"
echo "========================================"

echo "Enabling and starting Nomad service..."
systemctl enable nomad
systemctl restart nomad

echo "Waiting for Nomad to start..."
sleep 5

echo "Verifying Nomad status..."
nomad node status

echo ""
echo "✓ Nomad is running!"
echo ""
