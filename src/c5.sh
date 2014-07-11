
echo "=== Creating Mysql DB (c5)..."
mysql -u root -e "create database c5"

if [ ! -f concrete5.* ]; then
	echo "=== Downloading concrete5..."
	wget -q -O concrete5.latest.zip http://www.concrete5.org/download_file/-/view/66159/8497/
fi

echo "=== Unzipping concrete5..."
apt-get -y install unzip
# Become vagrant user to set file ownership correctly:
su vagrant -c 'unzip -q concrete5.*'
mv -n concrete5.*/* www
rm -rf concrete5.*/*
rmdir concrete5.*

echo "=== Installing concrete5..."
wget -q --no-check-certificate https://raw.githubusercontent.com/concrete5/concrete5/master/cli/install-concrete5.php
chmod 755 ./install-concrete5.php
./install-concrete5.php --db-server=localhost --db-username=root --db-database=c5 \
	--admin-password=admin --admin-email=admin@example.com \
	--starting-point=standard --target=./www
rm ./install-concrete5.php

# Enable pretty URL:s in the DB
mysql -u root -e "use c5; INSERT INTO Config (cfKey, timestamp, cfValue) VALUES ('URL_REWRITING', NOW(), 1)"

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

echo "=== Done!"
