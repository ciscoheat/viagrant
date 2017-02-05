echo "=== Installing Haxe targets:"

echo "=== Installing C++..."
apt-get install -y g++

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

echo "=== Installing Hashlink"
sudo apt-get install -y make cmake
cd hashlink-1.1
### ARCH=64 sudo apt-get install -y make cmake libvorbis-dev libz-dev zlib1g-dev libturbojpeg libpng-dev libsdl2-dev
### ARCH=32
dpkg --add-architecture i386
apt-get update -y
apt-get install libvorbis-dev:i386 -y
apt-get install gcc-multilib libz-dev:i386 zlib1g-dev:i386 libturbojpeg:i386 libpng-dev:i386 libsdl2-dev:i386 libegl1-mesa-dev:i386 libgles2-m esa-dev:i386 libmirclient-dev:i386 libmircommon-dev:i386 libxkbcommon-dev:i386 -y
sudo ldconfig
###
curl https://codeload.github.com/HaxeFoundation/hashlink/tar.gz/1.1 | tar xz
rm CMakeCache.txt && rm cmake_install.cmake && rm Makefile
cmake -DBUILD=make -DARCH=32 . && make && (
	cd bin
	cp -f hl /usr/bin
	mkdir -p /usr/lib/hl
	cp -f *.hdll /usr/lib/hl
	cp -f libhl.so.0.1.0 /usr/lib/hl
	ln -f -s /usr/lib/hl/libhl.so.0.1.0 /usr/lib/hl/libhl.so.0
	ln -f -s /usr/lib/hl/libhl.so.0 /usr/lib/hl/libhl.so
	ln -f -s /usr/lib/hl/libhl.so.0 /usr/lib/libhl.so.0
	cd ..
)
cd ..

# In /vagrant/bin/hl
# gcc -o tests -D INCLUDE_ALL -std=c11 tests.c -Lhl -I. -Isrc
