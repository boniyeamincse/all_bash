#!/bin/bash

# Update system packages
sudo yum update -y

# Install Apache Web Server
sudo yum install httpd -y

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Check Apache status
sudo systemctl status httpd

# Configure firewall
sudo firewall-cmd --add-service=http
sudo firewall-cmd --add-service=https
sudo systemctl restart firewalld

# Remove default welcome page
sudo rm /etc/httpd/conf.d/welcome.conf

# Restart Apache
sudo systemctl restart httpd

# Install PHP and required modules
sudo yum install php php-mysql php-pdo php-gd php-mbstring -y

# Create a test PHP file
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Restart Apache
sudo systemctl restart httpd

# Install MariaDB database server
sudo yum install mariadb-server mariadb -y

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Set root password (replace `your_password` with your desired password)
read -p "Enter new password: " password
echo "y" | mysql -uroot -p"$password" << EOF
SET PASSWORD FOR root@localhost = PASSWORD('$password');
UPDATE mysql.user SET Password = PASSWORD('$password') WHERE User = 'root';
DELETE FROM mysql.user WHERE User = '';
DELETE FROM mysql.user WHERE User = 'root' AND Host = '%';
FLUSH PRIVILEGES;
EOF

# Test MariaDB connection
mysql -u root -p"$password" -e "show databases;"

# Install phpMyAdmin
# Replace "7" with the appropriate version for your system if needed

# For CentOS/RHEL 7
# sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# For all other systems
sudo yum install phpmyadmin -y

# Configure phpMyAdmin access

sudo echo "<Directory /usr/share/phpMyAdmin/>
  AddDefaultCharset UTF-8
  Require local
  Require all granted
</Directory>" > /etc/httpd/conf.d/phpMyAdmin.conf

# Restart Apache
sudo systemctl restart httpd

# Enable MariaDB and Apache on boot
sudo systemctl enable mariadb
sudo systemctl enable httpd

echo "LAMP stack installation complete!"
