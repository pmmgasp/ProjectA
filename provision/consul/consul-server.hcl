data_dir = "/var/lib/consul"
bind_addr = "192.168.44.2"

server = true
bootstrap_expect = 1

ui_config {
  enabled = true
}

client_addr = "0.0.0.0"

retry_join = ["192.168.44.2"]
