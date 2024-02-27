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

# Set a strong root password for MySQL (replace with your desired password)
mysql_root_password="your_strong_password"

# Update package lists
echo "Updating package lists..."
sudo $package_manager update &> /dev/null

# Install MySQL server package
echo "Installing MySQL server..."
sudo $package_manager install -y mysql-server &> /dev/null

# Secure MySQL installation (non-interactive mode)
echo "Securing MySQL installation..."
sudo mysql_secure_installation << EOF
Y
$mysql_root_password
$mysql_root_password
Y
Y
Y
Y
EOF

echo "MySQL installation complete!"
