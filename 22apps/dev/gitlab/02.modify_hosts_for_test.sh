#!/bin/sh

# add hosts
sudo echo "127.0.0.1  gitlab.localhost.com" | sudo tee -a /etc/hosts
sudo echo "127.0.0.1  minio.localhost.com" | sudo tee -a /etc/hosts
sudo echo "127.0.0.1  registry.localhost.com" | sudo tee -a /etc/hosts

# check added host
cat /etc/hosts

# restart DNS cache
#sudo killall -HUP mDNSResponder

# DNS Cache 갱신
dscacheutil -flushcache