# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Consul Server VM
  config.vm.define "consul" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "consul"
    node.vm.network :private_network, ip: "192.168.44.2"
    node.vm.provider "virtualbox" do |v|
      v.name = "Consul Server"
      v.memory = 768
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/consul.sh"
  end

  # Load Redis Server
  config.vm.define "redis" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "redis"
    node.vm.network :private_network, ip: "192.168.44.40"
    node.vm.provider "virtualbox" do |v|
      v.name = "Redis Server"
      v.memory = 640
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/redis.sh"
  end

  # Load Redis Server
  config.vm.define "nfs" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "nfs"
    node.vm.network :private_network, ip: "192.168.44.50"
    node.vm.provider "virtualbox" do |v|
      v.name = "NFS Server"
      v.memory = 640
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/nfs.sh"
  end


  config.vm.define "webserver1" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "webserver1"
      node.vm.network :private_network, ip: "192.168.44.10"
      node.vm.provider "virtualbox" do |v|
        v.name = "Webserver 1"
        v.memory = 768
        v.cpus = 1
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/web.sh"

      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

  config.vm.define "webserver2" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "webserver2"
      node.vm.network :private_network, ip: "192.168.44.11"
      node.vm.provider "virtualbox" do |v|
        v.name = "Webserver 2"
        v.memory = 768
        v.cpus = 1
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/web.sh"

      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

  config.vm.define "webserver3" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "webserver3"
      node.vm.network :private_network, ip: "192.168.44.12"
      node.vm.provider "virtualbox" do |v|
        v.name = "Webserver 3"
        v.memory = 768
        v.cpus = 1
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/web.sh"

      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

  # Database VM
  config.vm.define "db" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "db"
    node.vm.network :private_network, ip: "192.168.44.20"
    node.vm.provider "virtualbox" do |v|
      v.name = "Database"
      v.memory = 1024
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/db.sh"
  end

  # WebSocket Server VM
  config.vm.define "websocket" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "websocket"
    node.vm.network :private_network, ip: "192.168.44.30"
    node.vm.provider "virtualbox" do |v|
      v.name = "Websocket Server"
      v.memory = 640
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/websocket.sh"
  end

  # Load Balancer VM
  config.vm.define "loadbalancer1" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "loadbalancer1"
    node.vm.network :private_network, ip: "192.168.44.4"
    node.vm.provider "virtualbox" do |v|
      v.name = "Loadbalancer Master"
      v.memory = 640
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/loadbalancer.sh"
  end

  # Load Balancer VM
  config.vm.define "loadbalancer2" do |node|
    node.vm.box = "bento/ubuntu-22.04"
    node.vm.hostname = "loadbalancer2"
    node.vm.network :private_network, ip: "192.168.44.5"
    node.vm.provider "virtualbox" do |v|
      v.name = "Loadbalancer Backup"
      v.memory = 640
      v.cpus = 1
      v.linked_clone = true
    end
    node.vm.provision "shell", path: "./provision/loadbalancer.sh"
  end

end
