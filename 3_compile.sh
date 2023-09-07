#!/bin/bash

cd code/openmc
rm -rf build
mkdir build
cd build

make --preset=llvm_a100 -Dcuda_thrust_sort=on -Dsycl_sort=off -Dhip_thrust_sort=off -Ddebug=off -Ddevice_printf=off -Doptimize=on -DCMAKE_INSTALL_PREFIX=./install ..
make install
cd ../../..
