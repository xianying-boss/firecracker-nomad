#!/bin/bash
set -e

echo "========================================"
echo "Firecracker + Nomad Installation"
echo "========================================"
echo ""
echo "This script will run all installation steps using the Makefile."
echo "Press Ctrl+C to cancel, or Enter to continue..."
read -r

sudo make all

echo ""
echo "Installation complete! Please check the README.md in each directory for further details."
echo "You can monitor your cluster with 'make status'."
