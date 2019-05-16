#!/bin/bash

ln -s ~/buildroot buildroot
cd buildroot
git reset --hard HEAD^
git am ../*patch
make -j`nproc`
cp output/images/Image ../artifacts
cp output/images/rootfs.cpio ../artifacts
cp output/build/linux-5.0.14/vmlinux ../artifacts
cd ../
/opt/renode/tests/test.sh -r artifacts litex-linux.robot
