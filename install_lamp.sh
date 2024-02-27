#!/bin/bash

# Check if the user has root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with superuser privileges. Use sudo or run as root."
    exit 1
fi

# Function to install packages
install_packages() {
    local package_manager
    local install_command

    # Detect package manager
    if command -v apt-get &> /dev/null; then
        package_manager="apt-get"
        install_command="apt-get install -y"
    elif command -v yum &> /dev/null; then
        package_manager="yum"
        install_command="yum install -y"
    else
        echo "Error: Unable to find a supported package manager."
        exit 1
    fi

    # Install required packages
    echo "Updating package lists..."
    $package_manager update
    echo "Installing Apache, MySQL, PHP, and phpMyAdmin..."
    $install_command apache2 php mysql-server php-mysql unzip

    # Install phpMyAdmin (download and extract)
    echo "Downloading phpMyAdmin..."
    wget -O /tmp/phpmyadmin.zip https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
    echo "Extracting phpMyAdmin..."
    unzip -q /tmp/phpmyadmin.zip -d /usr/share/
    mv /usr/share/phpMyAdmin-* /usr/share/phpmyadmin
    echo "Cleaning up..."
    rm /tmp/phpmyadmin.zip
}

# Function to configure Apache
configure_apache() {
    echo "Configuring Apache..."
    # Enable mod_rewrite
    a2enmod rewrite

    # Set ServerName to localhost
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

    # Allow .htaccess overrides
    sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

    # Restart Apache
    echo "Restarting Apache..."
    systemctl restart apache2
}

# Function to configure MySQL (or MariaDB)
configure_mysql() {
    echo "Configuring MySQL (or MariaDB)..."
    # Set root password for MySQL (or MariaDB)
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password'; FLUSH PRIVILEGES;"
}

# Function to configure phpMyAdmin
configure_phpmyadmin() {
    echo "Configuring phpMyAdmin..."
    # Generate blowfish_secret for phpMyAdmin configuration
    blowfish_secret=$(openssl rand -base64 32)

    # Create phpMyAdmin configuration file
    cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php

    # Update phpMyAdmin configuration
    sed -i "s/\['blowfish_secret'\] = ''/\['blowfish_secret'\] = '$blowfish_secret'/" /usr/share/phpmyadmin/config.inc.php
    sed -i "s/\['auth_type'\] = 'cookie'/\['auth_type'\] = 'config'/" /usr/share/phpmyadmin/config.inc.php
}

# Main script
install_packages
configure_apache
configure_mysql
configure_phpmyadmin

echo "Installation and configuration completed successfully."
