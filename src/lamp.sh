
echo "=== Installing Apache..."
apt-get install -y apache2

[ ! -d /vagrant/www ] && sudo -i -u ubuntu mkdir /vagrant/www

# Enable mod_rewrite, allow .htaccess and fix a virtualbox bug according to
# https://github.com/mitchellh/vagrant/issues/351#issuecomment-1339640
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/vagrant.conf
sed -i 's|DocumentRoot.*|DocumentRoot /vagrant/www|' /etc/apache2/sites-available/vagrant.conf
sed -i 's|ServerAdmin.*|<Directory "/vagrant/www">\n\t\tAllowOverride All\n\t\tRequire all granted\n\t</Directory>|' /etc/apache2/sites-available/vagrant.conf
echo EnableSendFile Off > /etc/apache2/conf-available/virtualbox-bugfix.conf

# Configure
a2enmod rewrite
a2ensite vagrant.conf
a2dissite 000-default.conf
a2enconf virtualbox-bugfix.conf

echo "=== Installing PHP..."
apt-get install -y php libapache2-mod-php php-gd php-mysql php-curl php-cli php-xdebug php-xml

cat > /etc/php/7.0/apache2/conf.d/vagrant.ini <<EOL
display_errors = On
html_errors = On
EOL
ln -s /etc/php/7.0/apache2/conf.d/vagrant.ini /etc/php/7.0/cli/conf.d

[ ! -d /vagrant/www/index.php ] && sudo -i -u ubuntu cat > /vagrant/www/index.php <<EOL
<?php phpinfo();
EOL

echo "=== Installing PHP utilities (Composer)..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin

echo "=== Installing PHP utilities (phing)..."
wget -q -O /usr/local/bin/phing.phar http://www.phing.info/get/phing-latest.phar && chmod 755 /usr/local/bin/phing.phar

echo "=== Installing Mysql..."
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server mysql-client

echo "=== Creating Mysql test DB..."
mysql -u root -e "create database test"

echo "=== Restarting Apache..."
service apache2 restart
