
echo "=== Installing Haxe 3.2.0..."
wget -q http://www.openfl.org/builds/haxe/haxe-3.2.0-linux-installer.tar.gz -O - | tar -xz
sh install-haxe.sh -y >/dev/null 2>&1
rm -f install-haxe.sh

echo /usr/lib/haxe/lib/ | haxelib setup
echo /usr/lib/haxe/lib/ > /home/vagrant/.haxelib
chown vagrant:vagrant /home/vagrant/.haxelib
