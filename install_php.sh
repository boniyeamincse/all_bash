#!/bin/bash

# Check distribution and set package manager
if [ -f /etc/os-release ]; then
  # Use 'lsb_release' for Debian/Ubuntu based systems
  if [ `which lsb_release &> /dev/null; echo $?` -eq 0 ]; then
    distro=`lsb_release -is`
  else
    # Use 'cat /etc/os-release' for other systems
    distro=`cat /etc/os-release | grep -i '^ID=' | cut -d= -f2 | tr -d '"'`
  fi
else
  echo "Unsupported Linux distribution. Exiting..."
  exit 1
fi

# Define package manager based on distribution
case "$distro" in
  "centos"|"redhat"|"fedora")
    package_manager="yum"
    ;;
  "ubuntu"|"debian")
    package_manager="apt-get"
    ;;
  *)
    echo "Unsupported Linux distribution. Exiting..."
    exit 1
    ;;
esac

# Update package lists
echo "Updating package lists..."
sudo $package_manager update &> /dev/null

# Install PHP and required extensions
echo "Installing PHP and extensions..."
case "$distro" in
  "centos"|"redhat"|"fedora")
    sudo $package_manager install -y php php-common php-mbstring php-xml php-json php-gd php-openssl
    ;;
  "ubuntu"|"debian")
    sudo $package_manager install -y php php-mbstring php-xml php-json php-gd php-imagick php-openssl
    ;;
esac

# Verify PHP installation
echo "Verifying PHP installation..."
php -v &> /dev/null
if [ $? -ne 0 ]; then
  echo "Error: PHP installation failed."
  exit 1
fi

echo "PHP and Laravel extensions installed successfully!"
