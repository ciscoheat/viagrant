
echo "=== Installing Haxe 3.4.x..."
add-apt-repository ppa:haxe/releases -y
apt-get update
apt-get install haxe -y

sudo -i -u ubuntu mkdir /home/ubuntu/haxelib 
sudo -i -u ubuntu haxelib setup /home/ubuntu/haxelib
