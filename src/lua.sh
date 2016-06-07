
echo "=== Installing Lua..."
apt-get -y install lua5.2 unzip libpcre3 libpcre3-dev

# Add source files so luarocks works
mkdir -p /usr/include/lua/5.2
wget http://www.lua.org/ftp/lua-5.2.0.tar.gz
tar xf lua-5.2.0.tar.gz
cp lua-5.2.0/src/* /usr/include/lua/5.2/
rm -rf lua-5.2.0
rm -f lua-5.2.0.tar.gz

# Compile luarocks itself
sudo apt-get -y install make
wget http://luarocks.org/releases/luarocks-2.3.0.tar.gz
tar zxpf luarocks-2.3.0.tar.gz
cd luarocks-2.3.0
./configure
make build
make install
cd ..
rm -f luarocks-2.3.0.tar.gz
rm -rf luarocks-2.3.0

# Install lua pcre so it works with Haxe
luarocks install lrexlib-pcre 2.7.2-1
