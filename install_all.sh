#!/bin/bash
set -e

echo "========================================"
echo "Firecracker + Nomad Cluster Installation"
echo "========================================"
echo ""
echo "This script will orchestrate the installation using the Makefile."
echo "Press Ctrl+C to cancel, or Enter to continue..."
read -r

sudo make all

echo ""
echo "Installation complete!"
echo "Monitor your cluster with 'make status'."
