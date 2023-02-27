#!/bin/bash -ex
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR
BUILD_DIR=$DIR/build
cd $BUILD_DIR
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.1.tar.xz
tar xf linux-6.2.1.tar.xz
cd linux-6.2.1
make defconfig
make -j$(nproc)
