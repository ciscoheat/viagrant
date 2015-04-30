
echo "=== Installing Haxe 3.2.0-rc2..."
wget -q http://www.openfl.org/builds/haxe/haxe-3.1.3-linux-installer.tar.gz -O - | tar -xz
sed -i 's/3\.1\.3/3\.2\.0-rc2/g' install-haxe.sh
sed -i 's/3,1,3/3,2,0-rc,2/g' install-haxe.sh
sh install-haxe.sh -y >/dev/null 2>&1
rm -f install-haxe.sh
echo | haxelib setup
