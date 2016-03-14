
echo "=== Installing Node.js..."
add-apt-repository ppa:chris-lea/node.js -y
apt-get update
apt-get install nodejs -y
# npm config set spin=false
