#!/usr/bin/env bash

Update () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get -y upgrade
}
Update

echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "-- Install tools and helpers --"
sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm

echo "-- Install PPA's --"
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:chris-lea/redis-server
Update

echo "-- Install NodeJS --"
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -

echo "-- Install packages --"
sudo apt-get install -y --force-yes apache2 mysql-server git-core nodejs rabbitmq-server redis-server
sudo apt-get install -y --force-yes php7.1-common php7.1-dev php7.1-json php7.1-opcache php7.1-cli libapache2-mod-php7.1 php7.1 php7.1-mysql php7.1-fpm php7.1-curl php7.1-gd php7.1-mcrypt php7.1-mbstring php7.1-intl php7.1-bcmath php7.1-zip
Update

echo "-- Configure PHP &Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/apache2/php.ini
sudo a2enmod rewrite

echo "-- Creating virtual hosts --"
sudo chown -Rf ubuntu:www-data /var/www/
sudo ln -fs /vagrant/public /var/www/app.dev


if [ -f /etc/apache2/sites-available/default.conf ]; then
   sudo rm /etc/apache2/sites-available/default.conf
fi

sudo touch /etc/apache2/sites-available/default.conf
cat << EOF | sudo tee -a /etc/apache2/sites-available/default.conf
<Directory "/var/www/">
    AllowOverride All
</Directory>

#
##  app.dev ##
#
<VirtualHost *:80>
    DocumentRoot "/var/www/app.dev"
    ServerName app.dev
    ServerAlias www.app.dev
</VirtualHost>

<VirtualHost *:80>
    DocumentRoot /var/www/phpmyadmin
    ServerName virtual.phpmyadmin.dev
</VirtualHost>
EOF
sudo a2ensite default.conf

echo "-- Restart Apache --"
sudo /etc/init.d/apache2 restart

echo "-- Install Composer --"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer


echo "-- Install phpMyAdmin --"
wget -k https://files.phpmyadmin.net/phpMyAdmin/4.7.6/phpMyAdmin-4.7.6-english.tar.gz
sudo tar -xzvf phpMyAdmin-4.7.6-english.tar.gz -C /var/www/
sudo rm phpMyAdmin-4.7.6-english.tar.gz
sudo mv /var/www/phpMyAdmin-4.7.6-english/ /var/www/phpmyadmin

echo "-- Setup databases --"
sudo mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
sudo mysql -uroot -proot -e "CREATE DATABASE my_database";