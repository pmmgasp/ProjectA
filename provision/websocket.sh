#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

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
    php8.1-zip \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-curl \
    php8.1-xml \
    php8.1-bcmath \
    zip \
    unzip

echo -e "$MSG_COLOR$(hostname): Install Composer (PHP)\033[0m"
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

echo -e "$MSG_COLOR$(hostname): Install dependencies for websockets server\033[0m"
cd /vagrant/ws
sudo -u vagrant bash -c 'composer install'

# Copy the systemd service file from project folder to system folder
echo -e "$MSG_COLOR$(hostname): Copying systemd service file for WebSocket server\033[0m"
sudo cp /vagrant/ws/wss.service /etc/systemd/system/wss.service

# Reload systemd to recognize the new service
echo -e "$MSG_COLOR$(hostname): Reloading systemd\033[0m"
sudo systemctl daemon-reload

# Enable the service to start on boot
echo -e "$MSG_COLOR$(hostname): Enabling WebSocket server service\033[0m"
sudo systemctl enable wss.service

# Start the service
echo -e "$MSG_COLOR$(hostname): Starting WebSocket server service\033[0m"
sudo systemctl start wss.service

# Check the status of the service
echo -e "$MSG_COLOR$(hostname): Checking WebSocket server service status\033[0m"
sudo systemctl status wss.service

echo -e "\033[42m$(hostname): Websocket server setup complete!\033[0m"
