#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages
install_packages() {
    local package_manager
    local install_command

    # Detect package manager
    if command_exists apt-get; then
        package_manager="apt-get"
        install_command="apt-get install -y"
    elif command_exists yum; then
        package_manager="yum"
        install_command="yum install -y"
    elif command_exists dnf; then
        package_manager="dnf"
        install_command="dnf install -y"
    elif command_exists pacman; then
        package_manager="pacman"
        install_command="pacman -Sy --noconfirm"
    else
        echo "Error: Unable to find a supported package manager."
        exit 1
    fi

    # Install required packages
    echo "Installing required packages..."
    $package_manager update
    $install_command apache2 php mysql-server php-mysql unzip
}

# Function to check if service is running and start if not
start_service() {
    local service_name="$1"

    if ! systemctl is-active --quiet "$service_name"; then
        systemctl start "$service_name"
    fi
}

# Check for Apache
if ! command_exists apache2; then
    echo "Apache is not installed. Installing Apache..."
    install_packages
else
    echo "Apache is already installed."
fi

# Check for MySQL or MariaDB
if ! command_exists mysql; then
    echo "MySQL (or MariaDB) is not installed. Installing MySQL..."
    install_packages
else
    echo "MySQL (or MariaDB) is already installed."
fi

# Check for other services if needed
# For example, you might need to check for PHP, unzip, etc.

# Start necessary services
echo "Starting required services..."
start_service apache2
start_service mysql

# Download and install phpMyAdmin
echo "Downloading and installing phpMyAdmin..."
# Replace the URL below with the latest version of phpMyAdmin
phpmyadmin_url="https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip"
wget -qO /tmp/phpmyadmin.zip "$phpmyadmin_url"
unzip -q /tmp/phpmyadmin.zip -d /var/www/html/
mv /var/www/html/phpMyAdmin-* /var/www/html/phpmyadmin
rm /tmp/phpmyadmin.zip

echo "phpMyAdmin installation completed successfully."
