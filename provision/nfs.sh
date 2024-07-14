#!/bin/bash
MSG_COLOR="\033[41m"

echo -e "$MSG_COLOR$(hostname): Update package lists\033[0m"
sudo apt-get update

echo -e "$MSG_COLOR$(hostname): Install NFS Server\033[0m"
sudo apt-get install -y nfs-kernel-server

echo -e "$MSG_COLOR$(hostname): Create the server folder and change the permissions\033[0m"
sudo mkdir /mnt/gallery
sudo chmod 777 /mnt/gallery/

echo -e "$MSG_COLOR$(hostname): Change exports file to grant access to client systems to the server folder\033[0m"
echo "/mnt/gallery 192.168.44.10/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
echo "/mnt/gallery 192.168.44.11/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
echo "/mnt/gallery 192.168.44.12/255.255.255.0(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

echo -e "$MSG_COLOR$(hostname): Export the NFS share directory and restart the NFS kernel server\033[0m"
sudo exportfs -a
sudo systemctl restart nfs-kernel-server

echo -e "\033[42m$(hostname): NFS Server setup complete!\033[0m"
