#!/bin/bash -ex
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

qemu-system-x86_64 \
  -hda $DIR/build/disk.img \
  -display none \
  -chardev stdio,id=terminal,mux=on \
  -device isa-debugcon,iobase=0x402,chardev=terminal \
  -serial chardev:terminal