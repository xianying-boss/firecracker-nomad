# Quick Start: Deploy Firecracker Jobs to Nomad

## Prerequisites Check

1. Ensure all installation steps are complete:
   ```bash
   firecracker --version
   nomad version
   ls -l /opt/firecracker/images/vmlinux.bin
   ls -l /opt/firecracker/images/rootfs.ext4
   ```

2. Verify Nomad is running:
   ```bash
   sudo systemctl status nomad
   nomad node status
   ```

## Option 1: Quick Deploy (Recommended for Testing)

### Step 1: Check Available Drivers
```bash
sudo bash /opt/firecracker/scripts/check_drivers.sh
```

### Step 2: Deploy Using Script
```bash
sudo bash /opt/firecracker/scripts/deploy_job.sh /opt/firecracker/jobs/firecracker-simple.hcl
```

### Step 3: Monitor in UI
Open browser: `http://localhost:4646`

## Option 2: Manual Deployment

### Using Simple Firecracker Job

```bash
# 1. Validate the job
nomad job validate /opt/firecracker/jobs/firecracker-simple.hcl

# 2. Plan the deployment
nomad job plan /opt/firecracker/jobs/firecracker-simple.hcl

# 3. Run the job
nomad job run /opt/firecracker/jobs/firecracker-simple.hcl

# 4. Check status
nomad job status firecracker-simple
```

### Using raw_exec Driver (If Firecracker plugin fails)

```bash
# 1. Update Nomad configuration
sudo cp /opt/firecracker/configs/nomad-dev.hcl /etc/nomad.d/nomad.hcl

# 2. Restart Nomad
sudo systemctl restart nomad
sleep 5

# 3. Verify raw_exec is enabled
nomad node status -self | grep raw_exec

# 4. Deploy job
nomad job run /opt/firecracker/jobs/firecracker-raw.hcl

# 5. Check status
nomad job status firecracker-raw
```

## Monitoring Your Jobs

### Check Job Status
```bash
# List all jobs
nomad job status

# Check specific job
nomad job status <job-name>
```

### Check Allocations
```bash
# Get allocation ID from job status, then:
nomad alloc status <allocation-id>

# View logs
nomad alloc logs <allocation-id>

# Follow logs
nomad alloc logs -f <allocation-id>
```

### Using the UI
1. Open browser: `http://localhost:4646` (or your server IP)
2. Navigate to "Jobs" section
3. Click on your job name to see details
4. View allocations, logs, and metrics

## Troubleshooting

### Job Not Appearing?

1. **Check if driver is detected:**
   ```bash
   nomad node status -self -verbose | grep -i driver
   ```

2. **Check Nomad logs:**
   ```bash
   sudo journalctl -u nomad -f
   ```

3. **Verify files exist:**
   ```bash
   ls -lh /opt/firecracker/images/
   ```

4. **Try the troubleshooting guide:**
   ```bash
   cat /opt/firecracker/TROUBLESHOOTING.md
   ```

### Common Issues

**Issue: "Unknown driver firecracker"**
- Solution: Use raw_exec driver instead (see Option 2 above)

**Issue: "Failed to find kernel"**
- Solution: Download kernel and rootfs (see step 06 script)

**Issue: "Permission denied /dev/kvm"**
- Solution: 
  ```bash
  sudo chmod 666 /dev/kvm
  sudo usermod -aG kvm nomad
  sudo systemctl restart nomad
  ```

## Available Job Templates

Located in `/opt/firecracker/jobs/`:

1. **firecracker-simple.hcl** - Basic Firecracker VM (no networking)
2. **firecracker-demo.hcl** - Full-featured with networking
3. **firecracker-raw.hcl** - Uses raw_exec driver (more compatible)

## Next Steps

1. **Customize your job** - Edit the .hcl files to match your needs
2. **Add networking** - Configure CNI for VM networking
3. **Scale up** - Increase `count` in job file to run multiple VMs
4. **Add monitoring** - Use Nomad metrics and Prometheus
5. **Create custom images** - Build your own kernel and rootfs

## Useful Commands

```bash
# Stop a job
nomad job stop <job-name>

# Restart a job
nomad job stop <job-name>
nomad job run /opt/firecracker/jobs/<job-file>.hcl

# Force garbage collection
nomad system gc

# Check Nomad cluster status
nomad server members
nomad node status

# Access Nomad API
curl http://localhost:4646/v1/jobs
```

## Getting Help

If you're stuck, check:
1. `/opt/firecracker/TROUBLESHOOTING.md`
2. Nomad logs: `sudo journalctl -u nomad -f`
3. Run diagnostics: `sudo bash /opt/firecracker/scripts/check_drivers.sh`
