#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install Redis Server\033[0m"
sudo apt-get install -y redis-server

echo -e "$MSG_COLOR$(hostname): Configure Redis Server to listen on all interfaces\033[0m"
sudo sed -i "s/bind 127.0.0.1 ::1/bind 0.0.0.0/" /etc/redis/redis.conf

sudo systemctl restart redis-server

echo -e "\033[42m$(hostname): Redis Server setup complete!\033[0m"
