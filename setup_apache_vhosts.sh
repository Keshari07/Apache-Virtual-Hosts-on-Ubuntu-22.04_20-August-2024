#!/bin/bash

# Step 1: Update the package list and install Apache
sudo apt update
sudo apt install -y apache2

# Step 2: Create directories for the websites
sudo mkdir -p /var/www/example1.com/public_html
sudo mkdir -p /var/www/example2.com/public_html

# Step 3: Set permissions for the directories
sudo chown -R $USER:$USER /var/www/example1.com/public_html
sudo chown -R $USER:$USER /var/www/example2.com/public_html
sudo chmod -R 755 /var/www

# Step 4: Create sample HTML pages
echo "<html><body><h1>Welcome to Example1.com!</h1></body></html>" | sudo tee /var/www/example1.com/public_html/index.html
echo "<html><body><h1>Welcome to Example2.com!</h1></body></html>" | sudo tee /var/www/example2.com/public_html/index.html

# Step 5: Create virtual host configuration files
# Virtual Host for example1.com
sudo bash -c 'cat > /etc/apache2/sites-available/example1.com.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@example1.com
    ServerName example1.com
    ServerAlias www.example1.com
    DocumentRoot /var/www/example1.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Virtual Host for example2.com
sudo bash -c 'cat > /etc/apache2/sites-available/example2.com.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@example2.com
    ServerName example2.com
    ServerAlias www.example2.com
    DocumentRoot /var/www/example2.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Step 6: Enable the virtual host files
sudo a2ensite example1.com.conf
sudo a2ensite example2.com.conf

# Step 7: Disable the default site (optional)
sudo a2dissite 000-default.conf

# Step 8: Test the Apache configuration
sudo apache2ctl configtest

# Step 9: Restart Apache to apply the changes
sudo systemctl restart apache2

# Step 10: Update /etc/hosts file for local testing
sudo bash -c 'echo "127.0.0.1 example1.com" >> /etc/hosts'
sudo bash -c 'echo "127.0.0.1 example2.com" >> /etc/hosts'

# Final message
echo "Apache Virtual Hosts setup is complete. You can now access example1.com and example2.com in your browser."
