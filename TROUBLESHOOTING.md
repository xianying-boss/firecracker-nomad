# Firecracker Jobs Not Showing in Nomad Dashboard - Troubleshooting Guide

## Quick Diagnosis

Run the diagnostics script:
```bash
sudo bash /opt/firecracker/scripts/check_drivers.sh
```

## Common Issues and Solutions

### Issue 1: Firecracker Driver Not Detected

**Symptoms:**
- No firecracker driver appears in `nomad node status -self -verbose`
- Jobs fail with "driver not found" error

**Solutions:**

1. **Check if the plugin exists:**
   ```bash
   ls -l /opt/nomad/plugins/firecracker-task-driver
   ```

2. **Verify plugin permissions:**
   ```bash
   sudo chmod +x /opt/nomad/plugins/firecracker-task-driver
   sudo chown nomad:nomad /opt/nomad/plugins/firecracker-task-driver
   ```

3. **Check Nomad configuration:**
   ```bash
   cat /etc/nomad.d/nomad.hcl
   ```
   
   Ensure it has:
   ```hcl
   plugin_dir = "/opt/nomad/plugins"
   ```

4. **Restart Nomad:**
   ```bash
   sudo systemctl restart nomad
   sudo systemctl status nomad
   ```

5. **Check Nomad logs:**
   ```bash
   sudo journalctl -u nomad -f
   ```

### Issue 2: Use raw_exec Driver as Alternative

If the firecracker plugin doesn't work, use the `raw_exec` driver:

1. **Enable raw_exec in Nomad config:**
   ```bash
   sudo cp /opt/firecracker/configs/nomad-dev.hcl /etc/nomad.d/nomad.hcl
   sudo systemctl restart nomad
   ```

2. **Use the raw_exec job file:**
   ```bash
   nomad job run /opt/firecracker/jobs/firecracker-raw.hcl
   ```

### Issue 3: Missing Kernel or Rootfs

**Symptoms:**
- Job fails immediately
- Error mentions missing files

**Solution:**

1. **Check if kernel exists:**
   ```bash
   ls -lh /opt/firecracker/images/vmlinux.bin
   ```

2. **Check if rootfs exists:**
   ```bash
   ls -lh /opt/firecracker/images/rootfs.ext4
   ```

3. **Download missing files:**
   ```bash
   # Download kernel
   wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/vmlinux-5.10.bin \
     -O /opt/firecracker/images/vmlinux.bin

   # Download rootfs
   wget https://github.com/firecracker-microvm/firecracker/releases/download/v1.7.0/ubuntu-22.04.ext4 \
     -O /opt/firecracker/images/rootfs.ext4
   
   # Set permissions
   sudo chown -R nomad:nomad /opt/firecracker
   ```

### Issue 4: KVM Permission Issues

**Symptoms:**
- Job starts but fails with permission denied on /dev/kvm

**Solution:**
```bash
sudo chmod 666 /dev/kvm
sudo usermod -aG kvm nomad
sudo systemctl restart nomad
```

### Issue 5: Datacenter Mismatch

**Symptoms:**
- Job doesn't get scheduled
- No allocations created

**Solution:**

1. **Check node datacenter:**
   ```bash
   nomad node status -self | grep Datacenter
   ```

2. **Update job file to match:**
   Edit your job file and ensure datacenter matches:
   ```hcl
   job "example" {
     datacenters = ["dc1"]  # Must match your node's datacenter
   ```

## Step-by-Step Deployment

### Method 1: Using Firecracker Driver

1. **Validate configuration:**
   ```bash
   nomad node status -self -verbose | grep -i driver
   ```

2. **Deploy simple job:**
   ```bash
   nomad job validate /opt/firecracker/jobs/firecracker-simple.hcl
   nomad job run /opt/firecracker/jobs/firecracker-simple.hcl
   ```

3. **Check status:**
   ```bash
   nomad job status firecracker-simple
   ```

### Method 2: Using raw_exec Driver (Recommended if plugin fails)

1. **Update Nomad config:**
   ```bash
   sudo cp /opt/firecracker/configs/nomad-dev.hcl /etc/nomad.d/nomad.hcl
   sudo systemctl restart nomad
   ```

2. **Wait for Nomad to restart:**
   ```bash
   sleep 5
   nomad node status
   ```

3. **Deploy raw_exec job:**
   ```bash
   nomad job run /opt/firecracker/jobs/firecracker-raw.hcl
   ```

4. **Monitor deployment:**
   ```bash
   nomad job status firecracker-raw
   watch nomad job status firecracker-raw
   ```

### Method 3: Using the Deployment Script

```bash
sudo bash /opt/firecracker/scripts/deploy_job.sh /opt/firecracker/jobs/firecracker-simple.hcl
```

## Verifying Successful Deployment

1. **Check job list:**
   ```bash
   nomad job status
   ```

2. **View specific job:**
   ```bash
   nomad job status <job-name>
   ```

3. **Check allocations:**
   ```bash
   nomad alloc status <allocation-id>
   ```

4. **View logs:**
   ```bash
   nomad alloc logs <allocation-id>
   ```

5. **Access Nomad UI:**
   Open browser: `http://<your-server-ip>:4646`

## Testing Firecracker Directly

If Nomad jobs aren't working, test Firecracker directly:

```bash
# Create a minimal config
cat > /tmp/fc-config.json <<EOF
{
  "boot-source": {
    "kernel_image_path": "/opt/firecracker/images/vmlinux.bin",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "/opt/firecracker/images/rootfs.ext4",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "machine-config": {
    "vcpu_count": 1,
    "mem_size_mib": 128
  }
}
EOF

# Run Firecracker
sudo rm -f /tmp/firecracker.sock
sudo /usr/local/bin/firecracker --api-sock /tmp/firecracker.sock --config-file /tmp/fc-config.json
```

## Getting Help

If issues persist:

1. **Check Nomad logs:**
   ```bash
   sudo journalctl -u nomad -n 100 --no-pager
   ```

2. **Check system logs:**
   ```bash
   sudo dmesg | grep -i kvm
   ```

3. **Verify all components:**
   ```bash
   # Firecracker
   firecracker --version
   
   # Nomad
   nomad version
   
   # KVM
   ls -l /dev/kvm
   lsmod | grep kvm
   ```

4. **Export node information:**
   ```bash
   nomad node status -self -json > node-info.json
   ```

## Additional Resources

- [Nomad Job Specification](https://developer.hashicorp.com/nomad/docs/job-specification)
- [Firecracker Documentation](https://github.com/firecracker-microvm/firecracker/tree/main/docs)
- [Nomad Drivers](https://developer.hashicorp.com/nomad/docs/drivers)
