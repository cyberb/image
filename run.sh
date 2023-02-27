#!/bin/bash -ex

DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

BUILD_DIR=$DIR/build
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

./deps.sh
./build-kernel.sh
./build-image.sh
./qemu.sh