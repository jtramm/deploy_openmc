#!/bin/bash

cd code/openmc
rm -rf build
mkdir build
cd build

cmake --preset=spirv_aot -Dcuda_thrust_sort=off -Dsycl_sort=off -Dhip_thrust_sort=off -Ddebug=off -Ddevice_printf=off -Doptimize=on -DCMAKE_INSTALL_PREFIX=./install ..
make install
cd ../../..
