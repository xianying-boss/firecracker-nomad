#!/bin/bash

echo "========================================"
echo "Firecracker Job Deployment Script"
echo "========================================"
echo ""

# Check if job file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <job-file.hcl>"
    echo ""
    echo "Available jobs:"
    ls -1 /opt/firecracker/jobs/*.hcl 2>/dev/null || echo "No jobs found in /opt/firecracker/jobs/"
    exit 1
fi

JOB_FILE="$1"

if [ ! -f "$JOB_FILE" ]; then
    echo "Error: Job file not found: $JOB_FILE"
    exit 1
fi

echo "Job file: $JOB_FILE"
echo ""

# Step 1: Validate the job
echo "Step 1: Validating job..."
if nomad job validate "$JOB_FILE"; then
    echo "✓ Job validation successful"
else
    echo "✗ Job validation failed"
    exit 1
fi
echo ""

# Step 2: Plan the job
echo "Step 2: Planning job deployment..."
nomad job plan "$JOB_FILE"
echo ""

# Step 3: Ask for confirmation
read -p "Do you want to deploy this job? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 0
fi

# Step 4: Run the job
echo "Step 3: Running job..."
nomad job run "$JOB_FILE"
echo ""

# Step 5: Show job status
sleep 2
echo "Step 4: Checking job status..."
JOB_NAME=$(grep -E "^job" "$JOB_FILE" | head -1 | awk '{print $2}' | tr -d '"')
nomad job status "$JOB_NAME"
echo ""

echo "========================================"
echo "Deployment Complete!"
echo "========================================"
echo ""
echo "Useful commands:"
echo "  View job status:       nomad job status $JOB_NAME"
echo "  View allocations:      nomad alloc status <alloc-id>"
echo "  View logs:             nomad alloc logs <alloc-id>"
echo "  Stop job:              nomad job stop $JOB_NAME"
echo "  Access Nomad UI:       http://localhost:4646"
echo ""
