#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Unzip\033[0m"
sudo apt-get install -y unzip

echo -e "$MSG_COLOR$(hostname): Install Consul\033[0m"
wget https://releases.hashicorp.com/consul/1.19.1/consul_1.19.1_linux_amd64.zip
unzip consul_1.19.1_linux_amd64.zip
sudo mv consul /usr/local/bin/

echo -e "$MSG_COLOR$(hostname): Configure Consul\033[0m"
sudo mkdir -p /etc/consul.d
sudo cp /vagrant/provision/consul/consul-server.hcl /etc/consul.d/
sudo cp /vagrant/provision/consul/consul.service /etc/systemd/system/
sudo systemctl enable consul
sudo systemctl start consul

echo -e "\033[42m$(hostname): Consul server setup complete!\033[0m"
