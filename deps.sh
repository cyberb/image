#!/bin/bash -ex

sudo apt update
sudo apt install -y \
  build-essential \
  util-linux \
  initramfs-tools-core \
  flex \
  bison \
  libelf-dev \
  libssl-dev \
  parted \
  qemu \
  wget \
  bc \
  golang-go