{{rename}}

echo "=== Provision script finished!"
echo "Change timezone: sudo dpkg-reconfigure tzdata"
echo "Change hostname: sudo pico /etc/hostname && sudo pico /etc/hosts"
{{reload}}
