
echo "=== Installing mod_neko for Apache..."

cat > /etc/apache2/conf-available/neko.conf <<EOL
LoadModule neko_module /usr/lib/neko/mod_neko2.ndll
AddHandler neko-handler .n
DirectoryIndex index.n
EOL
a2enconf neko.conf

[ ! -d /vagrant/src ] && mkdir /vagrant/src
[ ! -d /vagrant/src/Index.hx ] && cat > /vagrant/src/Index.hx <<EOL
class Index {
    static function main() {
        trace("Hello World !");
    }
}
EOL

[ ! -d /vagrant/src/build.hxml ] && cat > /vagrant/src/build.hxml <<EOL
-neko ../www/index.n
-main Index
EOL

chown -R ubuntu:ubuntu /vagrant/src
su ubuntu -c 'cd /vagrant/src && haxe build.hxml'

service apache2 restart
