#!/usr/bin/env bash

echo "=== Starting provision script..."

cd /vagrant

echo "=== Adding 'cd /vagrant' to .profile"
cat >> /home/vagrant/.profile <<EOL

cd /vagrant
EOL

echo "=== Updating apt..."
apt-get update >/dev/null 2>&1
