#!/bin/bash

pwd
path=`pwd`
ln -s ~/buildroot buildroot
cd buildroot
git reset --hard HEAD^
ls $path
git am $path/*patch
make
cp output/images/Image $path/artifacts
cp output/images/rootfs.cpio $path/artifacts
cp output/build/linux-5.0.14/vmlinux $path/artifacts
cd $path
/opt/renode/tests/test.sh -r artifacts litex-linux.robot
