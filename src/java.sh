
echo "=== Installing Java 8 JDK (openjdk)..."
apt-get install python-software-properties -y
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get install openjdk-8-jdk -y

echo "If you have several java versions and want to switch:"
echo "sudo update-alternatives --config java"
echo "sudo update-alternatives --config javac"
echo ""
echo "Current java version:"
java -version
