
echo "=== Installing Haxe targets:"

echo "=== Installing C++..."
apt-get install -y gcc-multilib g++-multilib
haxelib install hxcpp >/dev/null 2>&1

echo "=== Installing C#..."
apt-get install -y mono-devel
haxelib install hxcs >/dev/null 2>&1

echo "=== Installing Java..."
apt-get install -y default-jdk
haxelib install hxjava >/dev/null 2>&1

echo "=== Installing Phantomjs (js testing)..."
apt-get install -y phantomjs

echo "=== Installing Node.js..."
apt-get install python-software-properties -y
add-apt-repository ppa:chris-lea/node.js -y
apt-get update
# One at a time, to prevent conflicts:
apt-get install nodejs -y
apt-get install node-legacy -y
apt-get install npm -y
