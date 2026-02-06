# Step 5: Running Firecracker Jobs

This step demonstrates how to deploy MicroVMs using Nomad.

## What this step does:
- Creates a sample Nomad job file at `/opt/firecracker/firecracker-job.nomad`.
- Provides templates for various Firecracker configurations.

## How to run:
```bash
sudo bash run.sh
```

## Running the Sample Job:
Once the script has run and you have your images ready, you can deploy the job:
```bash
nomad job run /opt/firecracker/firecracker-job.nomad
```

## Templates:
Check the `templates/` directory for more examples:
- `firecracker-simple.hcl`: Basic VM.
- `firecracker-demo.hcl`: Full-featured VM with networking.
- `firecracker-raw.hcl`: Using `raw_exec` driver if the plugin is not used.
