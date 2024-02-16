#!/bin/bash
sudo -i
yum update -y
sudo amazon-linux-extras install nginx1 -y
systemctl start nginx 
systemctl enable nginx 