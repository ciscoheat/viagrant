
echo "=== Installing Haxe 3.3.0-rc.1..."
wget -q http://ciscoheat.github.io/cdn/haxe/haxe-3.3.0-rc.1-linux-installer.sh
sh haxe-3.3.0-rc.1-linux-installer.sh -y >/dev/null 2>&1
rm -f haxe-3.3.0-rc.1-linux-installer.sh

echo /usr/lib/haxe/lib/ | haxelib setup
echo /usr/lib/haxe/lib/ > /home/vagrant/.haxelib
chown vagrant:vagrant /home/vagrant/.haxelib
