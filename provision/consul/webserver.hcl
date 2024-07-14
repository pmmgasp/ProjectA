data_dir = "/var/lib/consul"
bind_addr = "{{ GetInterfaceIP \"eth1\" }}"

server = false
retry_join = ["192.168.44.2"]

service {
  name = "webserver"
  port = 80
  check {
    id = "http"
    name = "HTTP on port 80"
    http = "http://localhost:80"
    interval = "10s"
    timeout = "1s"
  }
}