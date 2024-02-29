#!/bin/bash

# Function to detect distribution and package manager
detect_distribution() {
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
            PKG_MANAGER="apt"
        elif [ "$ID" = "centos" ] || [ "$ID" = "rhel" ] || [ "$ID" = "rocky" ] || [ "$ID" = "almalinux" ]; then
            PKG_MANAGER="yum"
        else
            echo "Unsupported distribution."
            exit 1
        fi
    else
        echo "Unsupported distribution."
        exit 1
    fi
}

# Update the system
update_system() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt update -y
        apt upgrade -y
    elif [ "$PKG_MANAGER" = "yum" ]; then
        yum -y update
    fi
}

# Install LAMP stack components
install_lamp() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt install -y apache2 php libapache2-mod-php mariadb-server php-mysql php-mbstring
    elif [ "$PKG_MANAGER" = "yum" ]; then
        yum -y install httpd php mariadb-server php-mysql php-mbstring
    fi
}

# Start and enable Apache
start_apache() {
    systemctl start apache2
    systemctl enable apache2
}

# Start and enable MariaDB (or MySQL)
start_mariadb() {
    systemctl start mariadb
    systemctl enable mariadb
}

# Secure MariaDB (or MySQL) installation
secure_mariadb() {
    mysql_secure_installation <<EOF

y
newpassword
newpassword
y
y
y
y
EOF
}

# Install phpMyAdmin
install_phpmyadmin() {
    if [ "$PKG_MANAGER" = "apt" ]; then
        apt install -y phpmyadmin
    elif [ "$PKG_MANAGER" = "yum" ]; then
        yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
        yum -y install phpmyadmin
    fi
}

# Restart Apache
restart_apache() {
    systemctl restart apache2
}

# Print URLs for accessing Apache and phpMyAdmin
print_urls() {
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    echo "Apache web server is now running. You can access it at: http://$IP_ADDRESS/"
    echo "phpMyAdmin is installed. You can access it at: http://$IP_ADDRESS/phpmyadmin/"
}

# Main function
main() {
    detect_distribution
    update_system
    install_lamp
    start_apache
    start_mariadb
    secure_mariadb
    install_phpmyadmin
    restart_apache
    print_urls
}

# Execute main function
main
