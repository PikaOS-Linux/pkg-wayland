# Add dependent repositories
sudo dpkg --add-architecture i386
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
touch /etc/apt/sources.list.d/pika.list
echo 'deb https://ppa.pika-os.com/ lunar main' > /etc/apt/sources.list.d/pika.list
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
apt update
# Clone Upstream
wget -nv https://gitlab.freedesktop.org/wayland/wayland/-/archive/1.22.0/wayland-1.22.0.tar.gz
tar -xf ./wayland-1.22.0.tar.gz
cp -rvf ./debian ./wayland-1.22.0/
cd ./wayland-1.22.0/

# Get build deps
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
apt-get build-dep -y ./
debuild -S -uc -us
cd ../

apt-get install -y pbuilder debootstrap devscripts debhelper sbuild debhelper ubuntu-dev-tools piuparts

apt install -y debian-archive-keyring
cp -rvf ./pbuilderrc /etc/pbuilderrc
mkdir -p /var/cache/pbuilder/hook.d/
cp -rvf ./hooks/* /var/cache/pbuilder/hook.d/
rm -rf /var/cache/apt/
mkdir -p /pbuilder-results
DIST=lunar ARCH=i386 pbuilder create --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates
echo 'starting build'
DIST=lunar ARCH=i386 pbuilder build ./*.dsc --distribution lunar --architecture i386 --debootstrapopts --include=ca-certificates

# Move the debs to output
mkdir -p ./output
mv /var/cache/pbuilder/result/*.deb ./output/ || sudo mv ../*.deb ./output/