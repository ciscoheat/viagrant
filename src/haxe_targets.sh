echo "=== Installing Haxe targets:"

echo "=== Installing C++..."
apt-get install -y gcc-multilib g++-multilib

echo "=== Installing C#..."
apt-get install -y mono-devel mono-mcs

echo "=== Installing Java..."
apt-get install -y openjdk-8-jdk

echo "=== Installing PHP..."
apt-get install -y php-cli

echo "=== Installing Flash (xvfb)..."
apt-get install -y xvfb
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sed -i -e 's/deb http/deb [arch=amd64] http/' "/etc/apt/sources.list.d/google-chrome.list" "/opt/google/chrome/cron/google-chrome"
sudo dpkg --add-architecture i386
sudo apt-get update
apt-get install -y libcurl3:i386 libglib2.0-0:i386 libx11-6:i386 libxext6:i386 libxt6:i386 libxcursor1:i386 libnss3:i386 libgtk2.0-0:i386

echo "=== Installing Phantomjs (js testing)..."
npm install -g phantomjs-prebuilt
