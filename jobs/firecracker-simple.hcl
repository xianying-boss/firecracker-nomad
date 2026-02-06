job "firecracker-simple" {
  datacenters = ["dc1"]
  type        = "service"

  group "vm-group" {
    count = 1

    task "simple-vm" {
      driver = "firecracker"

      config {
        # Path to kernel image
        Kernel = "/opt/firecracker/images/vmlinux.bin"
        
        # Root filesystem
        Drives = [
          {
            drive_id       = "rootfs"
            path_on_host   = "/opt/firecracker/images/rootfs.ext4"
            is_root_device = true
            is_read_only   = false
          }
        ]

        # Number of vCPUs
        Vcpus = 1
        
        # Memory in MB
        Mem = 128

        # Kernel boot arguments
        KernelArgs = "console=ttyS0 reboot=k panic=1 pci=off"
      }

      resources {
        cpu    = 250
        memory = 256
      }
    }
  }
}
