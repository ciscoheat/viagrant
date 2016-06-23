
echo "=== Installing ArangoDB..."
wget -q https://www.arangodb.com/repositories/arangodb3/xUbuntu_12.04/Release.key
apt-key add - < Release.key
rm -f Release.key

echo 'deb https://www.arangodb.com/repositories/arangodb3/xUbuntu_12.04/ /' | sudo tee /etc/apt/sources.list.d/arangodb.list
echo arangodb3 arangodb/password password "" | debconf-set-selections
echo arangodb3 arangodb/password_again password "" | debconf-set-selections

apt-get install apt-transport-https -y
apt-get update
apt-get install arangodb3=3.0.0 -y

# Change endpoint binding so the admin interface can be used with Vagrant port forwarding
sed -i "s|^endpoint = tcp://127.0.0.1:8529|endpoint = tcp://0.0.0.0:8529|" /etc/arangodb3/arangod.conf

# Sometimes the database version check fails, so making an upgrade.
/etc/init.d/arangodb3 stop
arangod --database.auto-upgrade
/etc/init.d/arangodb3 start

echo "ArangoDB server daemon (default HTTP port 8529)"
echo "sudo /etc/init.d/arangodb3 <start|stop|status>"
