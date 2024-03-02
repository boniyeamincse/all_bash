#!/bin/bash

install_ansible() {
    echo "Installing Ansible..."

    # Detect distribution
    if [ -f /etc/os-release ]; then
        # For systems using systemd (e.g., Ubuntu, Fedora, CentOS)
        source /etc/os-release
        if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
            sudo apt-get update
            sudo apt-get install -y ansible
        elif [ "$ID" == "fedora" ] || [ "$ID" == "centos" ]; then
            sudo yum install -y ansible
        elif [ "$ID" == "arch" ]; then
            sudo pacman -S --noconfirm ansible
        else
            echo "Unsupported distribution. Please install Ansible manually."
            exit 1
        fi
    else
        echo "Unable to detect distribution. Please install Ansible manually."
        exit 1
    fi

    echo "Ansible installation complete."
}

# Check if Ansible is already installed
if command -v ansible &>/dev/null; then
    echo "Ansible is already installed."
else
    install_ansible
fi
