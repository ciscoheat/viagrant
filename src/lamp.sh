
mkdir www
chown vagrant:vagrant www

echo "=== Installing Apache..."
apt-get install -y apache2

# Enable mod_rewrite, allow .htaccess and fix a virtualbox bug according to
# https://github.com/mitchellh/vagrant/issues/351#issuecomment-1339640
a2enmod rewrite
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/sites-enabled/000-default
echo EnableSendFile Off > /etc/apache2/conf.d/virtualbox-bugfix

# Link to www dir
rm -rf /var/www
ln -fs /vagrant/www /var/www

echo "=== Installing curl..."
apt-get install -y curl

echo "=== Installing PHP..."
apt-get install -y php5 php5-gd php5-mysql php5-curl php5-cli php5-sqlite php5-xdebug php-apc

cat > /etc/php5/conf.d/vagrant.ini <<EOL
display_errors = On
html_errors = On
xdebug.max_nesting_level=1000
EOL

echo "=== Installing PHP utilities (Composer)..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin

echo "=== Installing PHP utilities (phing)..."
wget -q -O /usr/local/bin/phing.phar http://www.phing.info/get/phing-latest.phar && chmod 755 /usr/local/bin/phing.phar

echo "=== Installing Mysql..."
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server mysql-client

echo "=== Creating Mysql DB (test)..."
mysql -u root -e "create database test"

echo "=== Restarting Apache..."
service apache2 restart
