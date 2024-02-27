#!/bin/bash

# Check if the user has root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with superuser privileges. Use sudo or run as root."
    exit 1
fi

# Check if Apache is installed
if [ -x "$(command -v apache2)" ]; then
    echo "Apache is already installed."
else
    echo "Installing Apache..."
    
    # Install Apache based on the package manager of the OS
    if [ -x "$(command -v apt-get)" ]; then
        apt-get update
        apt-get install apache2 -y
    elif [ -x "$(command -v yum)" ]; then
        yum install httpd -y
    elif [ -x "$(command -v dnf)" ]; then
        dnf install httpd -y
    elif [ -x "$(command -v pacman)" ]; then
        pacman -Sy --noconfirm apache
    else
        echo "Error: Unable to find a supported package manager."
        exit 1
    fi
    
    echo "Apache installed successfully."
fi

# Start Apache service
echo "Starting Apache service..."
if [ -x "$(command -v systemctl)" ]; then
    systemctl start apache2 || systemctl start httpd
elif [ -x "$(command -v service)" ]; then
    service apache2 start || service httpd start
else
    echo "Error: Unable to start Apache service. Please start it manually."
    exit 1
fi

# Enable Apache to start on system boot
echo "Enabling Apache to start on boot..."
if [ -x "$(command -v systemctl)" ]; then
    systemctl enable apache2 || systemctl enable httpd
else
    echo "Warning: Unable to enable Apache to start on boot. Please enable it manually if required."
fi

echo "Apache setup completed successfully."
