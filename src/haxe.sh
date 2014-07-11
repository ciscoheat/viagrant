
echo "=== Installing Haxe..."
wget -q http://www.openfl.org/builds/haxe/haxe-3.1.3-linux-installer.tar.gz -O - | tar -xz
sh install-haxe.sh -y >/dev/null 2>&1
rm -f install-haxe.sh
