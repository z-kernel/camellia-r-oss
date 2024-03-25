#!/bin/bash
set -m
ls /opt/build
echo "*********************************"
ls /opt/build/tools
echo "*********************************"
ls $CLANG_TOOLCHAINS
echo "*********************************"
ls $BUILDTOOLS_TOOLCHAINS
echo "*********************************"
ls $GCC_TOOLCHAINS
echo "*********************************"
ls $KERNEL_SRC
echo "*********************************"
sudo chmod -R 777 /opt/build

export PATH="$CLANG_TOOLCHAINS:$BUILDTOOLS_TOOLCHAINS/path/linux-x86:$GCC_TOOLCHAINS:$PATH"

export BRANCH=android-4.14
export KERNEL_DIR=common

export CC=clang
export LD=ld.lld
export CLANG_PREBUILT_BIN=$CLANG_TOOLCHAINS
export BUILDTOOLS_PREBUILT_BIN=$BUILDTOOLS_TOOLCHAINS/path/linux-x86

export EXTRA_CMDS=''
export STOP_SHIP_TRACEPRINTK=1

export ARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-android-
export LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN=$GCC_TOOLCHAINS
#export FILES="
#arch/arm64/boot/Image.gz
#vmlinux
#System.map
#"

pushd $KERNEL_SRC
make O=out ARCH=$ARCH camellia_defconfig

make -j$(nproc --all) O=out \
	CC=$CC \
	LD=$LD \
	ARCH=$ARCH \
	CLANG_TRIPLE=$CLANG_TRIPLE \
	CROSS_COMPILE=$CROSS_COMPILE \
	2>&1 | tee out/kernel.log

tar -czvf out.tar.gz out
popd
