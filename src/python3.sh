
echo "=== Installing Python 3.4..."
apt-get install python-software-properties -y
add-apt-repository ppa:fkrull/deadsnakes -y
apt-get update
apt-get install python3.4 -y
rm -f /usr/bin/python
ln -s /usr/bin/python3.4 /usr/bin/python
