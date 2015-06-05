
echo "=== Creating Mysql DB (c5)..."
mysql -u root -e "create database c5"

echo "=== Downloading concrete5.7..."
if [ ! -f concrete5.* ]; then
    wget -q -O concrete5.7.4.2.zip http://www.concrete5.org/download_file/-/view/79252/
else
    echo "Concrete zip package already exists, using it instead of downloading."
fi

echo "=== Unzipping concrete5.7..."
apt-get -y install unzip
# Become vagrant user to set file ownership correctly:
su vagrant -c 'unzip -q concrete5.*'
mv -n concrete5.*/* www
rm -rf concrete5.*/*
rmdir concrete5.*

echo "=== Installing concrete5.7..."
wget -q --no-check-certificate https://raw.githubusercontent.com/concrete5/concrete5/release/5.7.4.2/cli/install-concrete5.php
chmod 755 ./install-concrete5.php
# Starting point can be elemental_full or elemental_blank
./install-concrete5.php --db-server=localhost --db-username=root --db-database=c5 \
	--admin-password=admin --admin-email=admin@example.com \
	--starting-point=elemental_full --target=./www
rm ./install-concrete5.php

# Enable pretty URL:s
mkdir ./www/application/config/generated_overrides
cat > ./www/application/config/generated_overrides/concrete.php <<EOL
<?php
return array(
    'site' => 'concrete5 Site',
    'version_installed' => '5.7.4.2',
    'misc' => array(
        'access_entity_updated' => 1433518474,
        'seen_introduction' => true,
        'latest_version' => '5.7.4.2'
    ),
    'external' => array(
        'news_overlay' => false,
        'news' => false
    ),
    'seo' => array(
        'canonical_url' => '',
        'canonical_ssl_url' => '',
        'redirect_to_canonical_url' => 0,
        'url_rewriting' => 1
    ),
    'debug' => array(
        'detail' => 'debug',
        'display_errors' => true
    )
);
EOL

# Write a .htaccess file for pretty URL:s
cat > ./www/.htaccess <<EOL

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

chown -R vagrant:vagrant ./www/application/config/generated_overrides
chown vagrant:vagrant ./www/.htaccess
