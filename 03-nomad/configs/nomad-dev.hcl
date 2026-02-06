data_dir = "/opt/nomad/data"
plugin_dir = "/opt/nomad/plugins"

bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  
  servers = ["127.0.0.1"]
  
  options {
    "driver.raw_exec.enable" = "1"
  }
  
  host_volume "images" {
    path = "/opt/firecracker/images"
    read_only = false
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

ui {
  enabled = true
}

telemetry {
  prometheus_metrics = true
}
