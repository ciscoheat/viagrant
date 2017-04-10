
echo "=== Installing Node.js 6.x..."
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install -y nodejs

sudo -u ubuntu -i mkdir /home/ubuntu/.npm-global
sudo -u ubuntu -i npm config set prefix '~/.npm-global'

sudo -u ubuntu -i cat >> /home/ubuntu/.profile <<EOL
PATH=~/.npm-global/bin:\$PATH
EOL
