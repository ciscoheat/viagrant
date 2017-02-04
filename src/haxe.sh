
echo "=== Installing Haxe 3.4.0..."
add-apt-repository ppa:haxe/releases -y
apt-get update
apt-get install haxe -y

sudo -i -u ubuntu sh -c 'echo /home/ubuntu/haxelib | haxelib setup'
sudo -i -u ubuntu haxelib install travix
