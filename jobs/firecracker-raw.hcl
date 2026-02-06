job "firecracker-raw" {
  datacenters = ["dc1"]
  type        = "service"

  group "firecracker" {
    count = 1

    task "vm" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/firecracker"
        args    = ["--api-sock", "/tmp/firecracker.sock", "--config-file", "local/vm-config.json"]
      }

      template {
        data = <<EOH
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
    "mem_size_mib": 256,
    "ht_enabled": false
  }
}
EOH

        destination = "local/vm-config.json"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
