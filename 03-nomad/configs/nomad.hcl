data_dir = "/opt/nomad/data"
plugin_dir = "/opt/nomad/plugins"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true

  options {
    "driver.firecracker.enable" = "1"
  }
}

plugin "firecracker" {
  config {
    # Path to firecracker binary
    firecracker_binary = "/usr/local/bin/firecracker"

    # Enable kernel overcommit (if needed)
    disable_overcommit = false
  }
}
