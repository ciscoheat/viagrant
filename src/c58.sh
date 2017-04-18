echo "=== Installing requirements..."
apt-get install -y php7.0-mbstring php-zip unzip
apachectl graceful

echo "=== Creating Mysql DB (c5)..."
mysql -u root -e "create database c5"
mysql -u root -e "GRANT ALL PRIVILEGES ON c5.* To 'c5'@'localhost' IDENTIFIED BY 'c5'"

echo "=== Downloading concrete5..."
if [ ! -f concrete5* ]; then
    wget -q --no-check-certificate -O concrete5-8.1.0.zip https://www.concrete5.org/download_file/-/view/93797/
else
    echo "Concrete zip package already exists, using it instead of downloading."
fi

echo "=== Unzipping concrete5..."
# Become ubuntu user to set file ownership correctly:
su ubuntu -c 'unzip -q concrete5*'
rm -f www/index.php
mv -n concrete5*/* www
rm -rf concrete5*/*
rmdir concrete5* 2> /dev/null

# Write a .htaccess file for pretty URL:s
sudo -u ubuntu cat > www/.htaccess <<EOL
# -- concrete5 urls start --
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME}/index.html !-f
    RewriteCond %{REQUEST_FILENAME}/index.php !-f
    RewriteRule . index.php [L]
</IfModule>
# -- concrete5 urls end --

EOL

echo "=== concrete5-8 ready to install. ==="
