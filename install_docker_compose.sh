#!/bin/bash

# Update and upgrade packages
sudo yum update -y
sudo yum upgrade -y

# Install curl if not already installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing..."
    sudo yum install curl -y
fi

# Download and install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Check Docker Compose version
docker-compose --version

# Check Docker Compose status
docker-compose ps
