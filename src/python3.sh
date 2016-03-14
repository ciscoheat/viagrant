
echo "=== Installing Python 3.4..."
add-apt-repository ppa:fkrull/deadsnakes -y
apt-get update
apt-get install python3.4 -y
ln -s /usr/bin/python3.4 /usr/bin/python3
