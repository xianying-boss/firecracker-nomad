#!/bin/bash

echo "========================================"
echo "Monitoring and Troubleshooting"
echo "========================================"

echo ""
echo "Useful monitoring commands:"
echo ""
echo "1. View Nomad logs:    journalctl -u nomad -f"
echo "2. Check node status:  nomad node status"
echo "3. View all jobs:      nomad job status"
echo "4. View allocations:   nomad alloc status <allocation-id>"
echo "5. Check driver:       nomad node status -self | grep firecracker"
echo "6. Nomad UI:           http://localhost:4646"
echo ""
