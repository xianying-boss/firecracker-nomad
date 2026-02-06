data_dir = "/opt/nomad/data"
plugin_dir = "/opt/nomad/plugins"

# Bind address for Nomad
bind_addr = "0.0.0.0"

# Server configuration
server {
  enabled          = true
  bootstrap_expect = 1
}

# Client configuration
client {
  enabled = true
  
  # Node metadata
  meta {
    "node-type" = "firecracker"
  }
  
  # Enable host volumes
  host_volume "firecracker-images" {
    path      = "/opt/firecracker/images"
    read_only = false
  }
}

# Plugin configuration
plugin "raw_exec" {
  config {
    enabled = true
  }
}

# Enable firecracker driver
plugin "firecracker-task-driver" {
  config {
    enabled = true
  }
}

# Telemetry
telemetry {
  collection_interval = "1s"
  disable_hostname = false
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}

# UI configuration
ui {
  enabled = true
}
