{{rename}}

echo "=== Adding 'cd /vagrant' to .profile"
sudo -u ubuntu -i cat >> /home/ubuntu/.profile <<EOL

cd /vagrant
EOL

echo "=== Provision script finished!"
echo "Start with 'vagrant reload && vagrant ssh'."
echo "Change timezone: sudo dpkg-reconfigure tzdata"
