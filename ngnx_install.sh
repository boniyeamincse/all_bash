#!/bin/bash

# Update system
sudo yum update -y

# Adding the EPEL Software Repository
sudo yum install epel-release -y

# Install Nginx
sudo yum install nginx -y

# Allowing HTTP and HTTPS traffic through firewall
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

# Display firewall status
echo "Firewall Status:"
sudo firewall-cmd --list-all

# Start Nginx on boot and then start it
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Nginx installation and setup completed."
