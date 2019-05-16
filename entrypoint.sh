#!/bin/bash

#ln -s ~/buildroot buildroot
cd buildroot
#git am ../*patch
make -j`nproc` linux
cp output/images/Image ../artifacts
cp output/build/linux-5.0.14/vmlinux ../artifacts
cd ../
/opt/renode/tests/test.sh -r artifacts litex-linux.robot
