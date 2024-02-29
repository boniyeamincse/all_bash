#!/bin/bash

# Update the system
yum -y update

# Install Apache web server
yum -y install httpd

# Start Apache and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Allow Apache through firewall
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

# Install PHP and necessary modules
yum -y install php php-mysql php-pdo php-gd php-mbstring

# Create a PHP info file
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Restart Apache to apply changes
systemctl restart httpd

# Set timezone in PHP configuration file
sed -i 's/;date.timezone =/date.timezone = Continent\/City/' /etc/php.ini

# Install MariaDB
yum -y install mariadb-server mariadb

# Start MariaDB and enable it to start on boot
systemctl start mariadb
systemctl enable mariadb

# Secure MariaDB installation
mysql_secure_installation <<EOF

y
newpasswd
newpasswd
y
y
y
y
EOF

# Install phpMyAdmin
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install phpmyadmin

# Configure phpMyAdmin
cat <<EOF > /etc/httpd/conf.d/phpMyAdmin.conf
<Directory /usr/share/phpMyAdmin/>
   AddDefaultCharset UTF-8
   Require local
   Require all granted
</Directory>
EOF

# Restart Apache
systemctl restart httpd

# Enable services to start on boot
systemctl enable mariadb
systemctl enable httpd

# Display URLs
echo "Apache web server is now running. You can access it at: http://$(hostname -I | cut -d' ' -f1)/"
echo "phpMyAdmin is installed. You can access it at: http://$(hostname -I | cut -d' ' -f1)/phpmyadmin/"

echo "LAMP installation completed successfully."
