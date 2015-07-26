
echo "=== Installing ArangoDB 2.6.2..."
apt-get install apt-transport-https -y
wget https://www.arangodb.com/repositories/arangodb2/xUbuntu_12.04/Release.key
apt-key add - < Release.key
rm -f Release.key
echo 'deb https://www.arangodb.com/repositories/arangodb2/xUbuntu_12.04/ /' >> /etc/apt/sources.list.d/arangodb.list
apt-get update
apt-get install arangodb=2.6.2 -y

echo "ArangoDB server daemon (default HTTP port 8529)"
echo "sudo /etc/init.d/arangodb <start|stop|status>"
