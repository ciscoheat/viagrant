
echo "=== Installing mod_neko for Apache..."

cat > /etc/apache2/conf.d/neko <<EOL
LoadModule neko_module /usr/lib/neko/mod_neko2.ndll
AddHandler neko-handler .n
DirectoryIndex index.n
EOL

mkdir /vagrant/src

cat > /vagrant/src/Index.hx <<EOL
class Index {
    static function main() {
        trace("Hello World !");
    }
}
EOL

cat > /vagrant/src/build.hxml <<EOL
-neko ../www/index.n
-main Index
EOL

chown -R vagrant:vagrant src
su vagrant -c 'cd /vagrant/src && haxe build.hxml'

service apache2 restart
