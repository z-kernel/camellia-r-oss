#!/bin/bash
set -m
sudo pacman -Sy aarch64-linux-gnu-binutils aarch64-linux-gnu-gcc --noconfirm
#export PATH="$CLANG_PATH:$AARCH64_PATH:$ARM32_PATH:$PATH"
export PATH="$CLANG_TOOLCHAINS:$PATH"

export ARCH=arm64
export SUBARCH=arm64
export CC=clang
#export DTC_EXT=dtc
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-android-
#export CROSS_COMPILE_ARM32=arm-linux-androideabi-

pushd camellia-r-oss
sudo chmod -R 777 out
make O=out ARCH=$ARCH camellia_defconfig

make -j$(nproc --all) O=out \
	ARCH=$ARCH \
	SUBARCH=$SUBARCH \
	CC=$CC \
	AR=llvm-ar \
	NM=llvm-nm \
	OBJCOPY=llvm-objcopy \
	OBJDUMP=llvm-objdump \
	STRIP=llvm-strip \
	CLANG_TRIPLE=$CLANG_TRIPLE \
	CROSS_COMPILE=$CROSS_COMPILE \
	2>&1 | tee out/kernel.log
popd
# export TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
# export TARGET=aarch64-linux-android
# # Set this to your minSdkVersion.
# export API=34

# export ARCH=arm64
# export SUBARCH=arm64
# export DTC_EXT=dtc
# # export CLANG_TRIPLE=aarch64-linux-gnu-

# # Configure and build.
# export AR=$TOOLCHAIN/bin/llvm-ar
# export CC=$TOOLCHAIN/bin/$TARGET$API-clang
# # export CROSS_COMPILE=$TOOLCHAIN/bin/$TARGET
# export AS=$CC
# export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
# export LD=$TOOLCHAIN/bin/ld
# export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
# export STRIP=$TOOLCHAIN/bin/llvm-strip

# make O=out ARCH=$ARCH camellia_defconfig

# make -j$(nproc --all) O=out \
#     ARCH=$ARCH \
#     CC=$CC \
#     2>&1 | tee out/kernel.log
