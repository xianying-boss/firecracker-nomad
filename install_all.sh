#!/bin/bash
set -e

echo "========================================"
echo "Firecracker + Nomad Installation Script"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo or as root"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "This script will install and configure Firecracker with Nomad"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read -r

# Run each step
echo ""
echo "Running Step 0: Checking Prerequisites..."
bash "${SCRIPT_DIR}/00_check_prerequisites.sh"

echo ""
echo "Running Step 1: Installing Firecracker..."
bash "${SCRIPT_DIR}/01_install_firecracker.sh"

echo ""
echo "Running Step 2: Installing Nomad..."
bash "${SCRIPT_DIR}/02_install_nomad.sh"

echo ""
echo "Running Step 3: Configuring Nomad..."
bash "${SCRIPT_DIR}/03_configure_nomad.sh"

echo ""
echo "Running Step 4: Installing Firecracker Task Driver..."
bash "${SCRIPT_DIR}/04_install_task_driver.sh"

echo ""
echo "Running Step 5: Setting Up Permissions..."
bash "${SCRIPT_DIR}/05_setup_permissions.sh"

echo ""
echo "Running Step 6: Preparing Firecracker Images..."
bash "${SCRIPT_DIR}/06_prepare_images.sh"

echo ""
echo "Running Step 7: Starting Nomad Service..."
bash "${SCRIPT_DIR}/07_start_nomad.sh"

echo ""
echo "Running Step 8: Creating Sample Job..."
bash "${SCRIPT_DIR}/08_create_sample_job.sh"

echo ""
echo "========================================"
echo "Installation Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Create or download a rootfs image for /opt/firecracker/images/rootfs.ext4"
echo "2. Validate the sample job: nomad job validate /opt/firecracker/firecracker-job.nomad"
echo "3. Run the sample job: nomad job run /opt/firecracker/firecracker-job.nomad"
echo ""
echo "For monitoring commands, check: ${SCRIPT_DIR}/09_monitoring_commands.sh"
echo ""
echo "Access Nomad UI at: http://localhost:4646"
echo ""
