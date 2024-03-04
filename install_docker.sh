#!/bin/bash

# Function to detect the Linux distribution
detect_linux_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        LINUX_DISTRO=$ID
    elif [ -f /etc/debian_version ]; then
        LINUX_DISTRO="debian"
    elif [ -f /etc/redhat-release ]; then
        LINUX_DISTRO="centos"
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
}

# Function to install Docker on Debian-based distributions
install_docker_debian() {
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/${LINUX_DISTRO}/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${LINUX_DISTRO} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
}

# Function to install Docker on Red Hat-based distributions
install_docker_centos() {
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/${LINUX_DISTRO}/docker-ce.repo
    sudo yum install -y docker-ce docker-ce-cli containerd.io
}

# Main script
detect_linux_distribution

case "$LINUX_DISTRO" in
    "debian")
        echo "Detected Debian-based Linux distribution."
        install_docker_debian
        ;;
    "centos")
        echo "Detected Red Hat-based Linux distribution."
        install_docker_centos
        ;;
    *)
        echo "Unsupported Linux distribution."
        exit 1
        ;;
esac

# Start Docker service
sudo systemctl start docker

# Check Docker version
docker --version

# Add current user to the docker group to run docker commands without sudo
sudo usermod -aG docker $USER

echo "Docker installation completed."
