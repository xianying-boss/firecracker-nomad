job "firecracker-demo" {
  datacenters = ["dc1"]
  type        = "service"

  group "firecracker-group" {
    count = 1

    network {
      mode = "host"
      port "http" {
        static = 8080
      }
    }

    task "firecracker-vm" {
      driver = "firecracker"

      config {
        # Kernel image path
        Kernel = "/opt/firecracker/images/vmlinux.bin"
        
        # Root filesystem path
        Drives = [
          {
            drive_id      = "rootfs"
            path_on_host  = "/opt/firecracker/images/rootfs.ext4"
            is_root_device = true
            is_read_only  = false
          }
        ]

        # vCPU configuration
        Vcpus = 1
        
        # Memory in MB
        Mem = 256

        # Kernel boot arguments
        KernelArgs = "console=ttyS0 reboot=k panic=1 pci=off"

        # Network configuration
        NetworkInterfaces = [
          {
            CNINetworkName = "bridge"
            HostDevName    = "tap0"
          }
        ]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      # Logs configuration
      logs {
        max_files     = 5
        max_file_size = 10
      }
    }
  }
}
