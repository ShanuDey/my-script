#!/bin/bash

echo "path="
pwd
echo "List of files/directories="
ls

echo "Setting Achitecture"
export ARCH=arm64 
export SUBARCH=arm64 

echo "Setting KBUILD Configuration"
export KBUILD_BUILD_USER="Developer" 
export KBUILD_BUILD_HOST="Equinox" 

echo "setting cross_compiler"
export CROSS_COMPILE=/home/runner/work/HMP/HMP/GCC-4.9-x64/bin/aarch64-linux-android-
export KBUILD_COMPILER_STRING=$(/home/runner/work/HMP/HMP/clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
export CROSS_COMPILE_ARM32=/home/runner/work/HMP/HMP/GCC-4.9-x32/bin/arm-linux-androideabi-

echo "making out directory"
mkdir -p out

echo "cleaning"
make clean
make mrproper

echo "compiling defconfig"
make O=out ARCH=arm64 X00T_defconfig

echo "kernel compiling stated"
make -j$(nproc --all) O=out ARCH=arm64 \
                        CC="/home/runner/work/HMP/HMP/clang/bin/clang" \
                        CLANG_TRIPLE="aarch64-linux-gnu-" \
                        2>&1 | tee kernel_build_log.txt
                        
