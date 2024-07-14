#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Apache HTTP Server\033[0m"
sudo apt-get install -y apache2

echo -e "$MSG_COLOR$(hostname): Install PHP 8.1\033[0m"
# Install specific versions of PHP packages
sudo apt install -y --no-install-recommends php8.1

echo -e "$MSG_COLOR$(hostname): Install additional PHP 8.1 modules\033[0m"
sudo apt-get install -y \
    php8.1-cli \
    php8.1-common \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-pdo \
    php8.1-redis \
    php8.1-zip \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-xml \
    php8.1-bcmath \
    zip \
    unzip

# sudo sh -c 'echo -e "<?php\nphpinfo();\n?>" > /var/www/html/phpinfo.php'

sudo sed -i "s/session.save_handler = files/session.save_handler = redis/" /etc/php/8.1/apache2/php.ini
sudo sed -i 's/;session.save_path = "\/var\/lib\/php\/sessions"/session.save_path = "tcp:\/\/192.168.44.40:6379"/' /etc/php/8.1/apache2/php.ini

sudo systemctl restart apache2

echo -e "$MSG_COLOR$(hostname): Install Consul\033[0m"
wget https://releases.hashicorp.com/consul/1.19.1/consul_1.19.1_linux_amd64.zip
unzip consul_1.19.1_linux_amd64.zip
sudo mv consul /usr/local/bin/

echo -e "$MSG_COLOR$(hostname): Configure Consul\033[0m"
sudo mkdir -p /etc/consul.d
sudo cp /vagrant/provision/consul/webserver.hcl /etc/consul.d/
sudo cp /vagrant/provision/consul/consul.service /etc/systemd/system/
sudo systemctl enable consul
sudo systemctl start consul

echo -e "$MSG_COLOR$(hostname): Install NFS\033[0m"
sudo apt-get install -y nfs-common

echo -e "$MSG_COLOR$(hostname): Create a client folder for NFS and change the permissions\033[0m"
sudo mkdir /mnt/clientgallery
sudo chmod 777 /mnt/clientgallery/

echo -e "$MSG_COLOR$(hostname): Add the mount point to the fstab file and mount all entries in the file\033[0m"
echo "192.168.44.50:/mnt/gallery /mnt/clientgallery nfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a

echo -e "$MSG_COLOR$(hostname): Install Composer (PHP)\033[0m"
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

echo -e "$MSG_COLOR$(hostname): Install dependencies for webapp\033[0m"
cd /vagrant/app
sudo -u vagrant bash -c 'composer install'

echo -e "$MSG_COLOR$(hostname): Copy apache config, disable the default site / enable ours\033[0m"
sudo cp /vagrant/provision/projectA.conf /etc/apache2/sites-available/
sudo a2dissite 000-default.conf
sudo a2ensite projectA.conf
sudo systemctl reload apache2

echo -e "$MSG_COLOR$(hostname): Update deploy date @ .env file\033[0m"
cd /vagrant/app
ISO_DATE=$(TZ=Europe/Lisbon date -Iseconds)
sed -i "s/^DEPLOY_DATE=.*/DEPLOY_DATE=\"$ISO_DATE\"/" .env

echo -e "\033[42m$(hostname): Webserver setup complete!\033[0m"
