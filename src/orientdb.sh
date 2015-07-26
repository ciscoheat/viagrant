
echo "=== Installing OrientDB 2.1-rc5..."
pushd /opt
wget -O orientdb.tar.gz "http://orientdb.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.1-rc5.tar.gz&os=linux"
tar -zxvf orientdb.tar.gz
mv orientdb-community* orientdb
rm -f orientdb.tar.gz
chown -R vagrant:vagrant orientdb
sed -i 's/<users>/<users><user name="root" password="root" resources="*" \/>/' /opt/orientdb/config/orientdb-server-config.xml
#chmod 640 /opt/orientdb/config/orientdb-server-config.xml
#useradd -d /opt/orientdb -M -r -s /bin/false -U orientdb
#chown -R orientdb:orientdb orientdb*
#chmod 775 /opt/orientdb/bin
#chmod g+x /opt/orientdb/bin/*.sh
#usermod -a -G orientdb vagrant
cp orientdb/bin/orientdb.sh /etc/init.d/
sudo sed -i "s|YOUR_ORIENTDB_INSTALLATION_PATH|/opt/orientdb|;s|USER_YOU_WANT_ORIENTDB_RUN_WITH|vagrant|" /etc/init.d/orientdb.sh
cd /etc/init.d
update-rc.d orientdb.sh defaults
/etc/init.d/orientdb.sh start
popd
echo "OrientDB server deamon:"
echo "sudo /etc/init.d/orientdb.sh <start|stop|status>"
