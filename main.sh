#! /bin/bash

DEBIAN_FRONTEND=noninteractive

# Clone Upstream

wget -nv https://gitlab.freedesktop.org/wayland/wayland/-/archive/1.23.0/wayland-1.23.0.tar.gz
tar -xf ./wayland-1.23.0.tar.gz
cp -rvf ./debian ./wayland-1.23.0/
cd ./wayland-1.23.0/

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
