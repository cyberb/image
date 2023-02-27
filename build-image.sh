#!/bin/bash -ex
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR
BUILD_DIR=$DIR/build
cd $BUILD_DIR

set -eE
clean () {
  sudo umount $BUILD_DIR/tmp || true
  sudo rm -rf $BUILD_DIR/tmp || true
  sudo losetup -d ${LOOP} || true
}
trap clean ERR
rm -rf disk.img
clean
truncate -s1G disk.img
parted -s disk.img mktable msdos
parted -s disk.img mkpart primary ext4 1 "100%"
parted -s disk.img set 1 boot on
sync
LOOP=$(sudo losetup -Pf --show disk.img)
LOOP_PART1="${LOOP}p1"

sudo mkfs -t ext4 -v "$LOOP_PART1"
mkdir $BUILD_DIR/tmp
sudo mount $LOOP_PART1 $BUILD_DIR/tmp
sudo chown -R $USER $BUILD_DIR/tmp
mkdir -p $BUILD_DIR/tmp/boot/grub
echo "(hd0) ${LOOP}" >$BUILD_DIR/tmp/boot/grub/device.map
sudo grub-install \
  -v \
  --directory=/usr/lib/grub/i386-pc \
  --boot-directory=$BUILD_DIR/tmp/boot \
  ${LOOP} \
  2>&1

cat >$BUILD_DIR/tmp/boot/grub/grub.cfg <<EOF
serial
terminal_input serial
terminal_output serial
set root=(hd0,1)
linux /boot/bzImage \
  root=/dev/sda1 \
  console=ttyS0 \
  init=/bin/hello
boot
EOF

cp $BUILD_DIR/linux-6.2.1/arch/x86/boot/bzImage $BUILD_DIR/tmp/boot/bzImage
cd $DIR
go build -o $BUILD_DIR/tmp/bin/hello
sync
clean