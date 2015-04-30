#!/usr/bin/env bash

echo "=== Starting provision script..."
echo "Change timezone: sudo dpkg-reconfigure tzdata"
echo "Change hostname: sudo pico /etc/hostname && sudo pico /etc/hosts"

cd /vagrant

echo "=== Adding 'cd /vagrant' to .profile"
cat >> /home/vagrant/.profile <<EOL

cd /vagrant
EOL

{{rename}}

echo "=== Updating apt..."
apt-get update >/dev/null 2>&1
