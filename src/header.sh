#!/usr/bin/env bash

cd /vagrant

echo "=== Adding 'cd /vagrant' to .profile"
cat >> /home/vagrant/.profile <<EOL

cd /vagrant
EOL

{{rename}}

echo "=== Updating apt..."
apt-get update >/dev/null 2>&1
