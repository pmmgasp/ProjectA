#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Unzip\033[0m"
sudo apt-get install -y unzip

echo -e "$MSG_COLOR$(hostname): Install Nginx\033[0m"
sudo apt-get install -y nginx

echo -e "$MSG_COLOR$(hostname): Install Consul\033[0m"
wget https://releases.hashicorp.com/consul/1.19.1/consul_1.19.1_linux_amd64.zip
unzip consul_1.19.1_linux_amd64.zip
sudo mv consul /usr/local/bin/

echo -e "$MSG_COLOR$(hostname): Install Consul Template\033[0m"
wget https://releases.hashicorp.com/consul-template/0.39.0/consul-template_0.39.0_linux_amd64.zip
unzip consul-template_0.39.0_linux_amd64.zip
sudo mv consul-template /usr/local/bin/

echo -e "$MSG_COLOR$(hostname): Configure Consul\033[0m"
sudo mkdir -p /etc/consul.d
sudo cp /vagrant/provision/consul/loadbalancer.hcl /etc/consul.d/
sudo cp /vagrant/provision/consul/consul.service /etc/systemd/system/
sudo systemctl enable consul
sudo systemctl start consul

echo -e "$MSG_COLOR$(hostname): Configure Nginx with Consul Template\033[0m"
sudo mkdir -p /etc/consul-template.d
sudo cp /vagrant/provision/nginx.ctmpl /etc/consul-template.d/
sudo cp /vagrant/provision/consul/consul-template.service /etc/systemd/system/
sudo systemctl enable consul-template
sudo systemctl start consul-template

echo -e "$MSG_COLOR$(hostname): Copy Nginx configuration\033[0m"
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

echo -e "$MSG_COLOR$(hostname): Restart Nginx\033[0m"
sudo systemctl restart nginx

echo -e "$MSG_COLOR$(hostname): Install keepalived\033[0m"
sudo apt-get install -y keepalived

echo -e "$MSG_COLOR$(hostname): Configure keepalived\033[0m"

if [ "$(hostname)" == "loadbalancer1" ]; then
  PRIORITY=100
  STATE=MASTER
else
  PRIORITY=99
  STATE=BACKUP
fi

sudo cp /vagrant/provision/keepalived.conf /etc/keepalived/keepalived.conf

sudo sed -i "s/{{ STATE }}/$STATE/g" /etc/keepalived/keepalived.conf
sudo sed -i "s/{{ PRIORITY }}/$PRIORITY/g" /etc/keepalived/keepalived.conf

sudo chmod 644 /etc/keepalived/keepalived.conf

sudo systemctl restart keepalived

echo -e "\033[42m$(hostname): Loadbalancer setup complete! Visit http://192.168.44.3\033[0m"