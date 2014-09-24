
echo "=== Creating Mysql DB (c5)..."
mysql -u root -e "create database c5"

if [ ! -f concrete5.* ]; then
	echo "=== Downloading concrete5.7..."
	wget -q -O concrete5.latest.zip http://www.concrete5.org/download_file/-/view/71216/
fi

echo "=== Unzipping concrete5.7..."
apt-get -y install unzip
# Become vagrant user to set file ownership correctly:
su vagrant -c 'unzip -q concrete5.*'
mv -n concrete5.*/* www
rm -rf concrete5.*/*
rmdir concrete5.*

echo "=== Installing concrete5.7..."
wget -q --no-check-certificate https://raw.githubusercontent.com/concrete5/concrete5-5.7.0/master/cli/install-concrete5.php
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

/**
 * -----------------------------------------------------------------------------
 * Generated 2014-09-24T00:23:46+00:00

 * @item      seo.url_rewriting
 * @group     concrete
 * @namespace null
 * -----------------------------------------------------------------------------
 */
return array(
    'site' => 'concrete5 Site',
    'misc' => array(
        'access_entity_updated' => 1411516320,
        'latest_version' => '5.6.3.1',
        'seen_introduction' => true
    ),
    'seo' => array(
        'url_rewriting' => 1
    )
);
EOL

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

chown -R vagrant:vagrant ./www/application/config/generated_overrides
chown vagrant:vagrant ./www/.htaccess

echo "=== Done!"
