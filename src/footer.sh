
{{rename}}

echo "=== Provision script finished!"
echo "Change timezone: sudo dpkg-reconfigure tzdata"
echo "Change hostname: sudo pico /etc/hostname && sudo pico /etc/hosts"
echo ""
echo "If you have renamed the vm with '-n', execute 'vagrant reload' to finish the process."
