
echo "=== Creating Mysql DB (c5)..."
mysql -u root -e "create database c5"

echo "=== Downloading concrete5..."
if [ ! -f concrete5.* ]; then
	wget -q -O concrete5.6.3.3.zip http://www.concrete5.org/download_file/-/view/75930/8497
else
	echo "Concrete zip package already exists, using it instead of downloading."
fi

echo "=== Unzipping concrete5..."
apt-get -y install unzip
# Become vagrant user to set file ownership correctly:
su vagrant -c 'unzip -q concrete5.*'
mv -n concrete5.*/* www
rm -rf concrete5.*/*
rmdir concrete5.*

echo "=== Installing concrete5..."
wget -q --no-check-certificate https://raw.githubusercontent.com/concrete5/concrete5-legacy/master/cli/install-concrete5.php
chmod 755 ./install-concrete5.php
./install-concrete5.php --db-server=localhost --db-username=root --db-database=c5 \
	--admin-password=admin --admin-email=admin@example.com \
	--starting-point=standard --target=./www
rm ./install-concrete5.php

# Enable pretty URL:s in the DB
mysql -u root -e "use c5; INSERT INTO Config (cfKey, timestamp, cfValue) VALUES ('URL_REWRITING', NOW(), 1)"

# Add adodb table for query logging
mysql -u root -e "use c5; CREATE TABLE adodb_logsql (created DATETIME NOT NULL, sql0 VARCHAR(250) NOT NULL, sql1 TEXT NOT NULL, params TEXT NOT NULL, tracer TEXT NOT NULL, timer DECIMAL(16,6) NOT NULL)"

# Write a .htaccess file for pretty URL:s
cat > ./www/.htaccess <<EOL
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME}/index.html !-f
RewriteCond %{REQUEST_FILENAME}/index.php !-f
RewriteRule . index.php [L]
</IfModule>
EOL

# Add some useful defines to site.php
cat >> ./www/config/site.php <<EOL

define('DATE_FORM_HELPER_FORMAT_HOUR', '24');
define('ENABLE_NEWSFLOW_OVERLAY', false);
EOL
