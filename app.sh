#!/bin/bash

sleep 30

sudo yum update -y

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip cocktails.zip
cd ~/cocktails && npm i --only=prod

sudo mv /tmp/cocktails.service /etc/systemd/system/cocktails.service
sudo systemctl enable cocktails.service
sudo systemctl start cocktails.service