#!/bin/bash

NDK=/PublicData/LinuxAndroidSdk/ndk/21.3.6528147
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
SYSROOT="$TOOLCHAIN/sysroot"
API=29

function build_android
{
echo "Compiling FFmpeg for $CPU"
CC="$TOOL_PREFIX$API-clang"
CXX="$TOOL_PREFIX$API-clang++"
PREFIX="${PWD}/android/$OUTPUT_FOLDER"
rm -rf $PREFIX
make clean
./configure \
    --prefix=$PREFIX \
    --libdir=$LIB_DIR \
    --enable-shared \
    --enable-jni \
	--enable-gpl \
    --enable-openssl \
    --enable-nonfree \
    --enable-mediacodec \
    --enable-libx264 \
    --disable-doc \
    --disable-static \
	--disable-ffmpeg \
	--disable-ffplay \
	--disable-ffprobe \
    --disable-symver \
    --disable-programs \
    --disable-demuxer=image_png_pipe \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --cc=$CC \
    --cxx=$CXX \
    --enable-cross-compile \
	--cross-prefix=$CROSS_PREFIX \
    --sysroot=$SYSROOT \
    --disable-asm \
    --disable-x86asm \
    --extra-cflags="-I/PublicData/openssl/openssl_1_1_1l/android/$ARCH/include -I/PublicDataBackup/libx264/x264/android/$ARCH/include -fPIE -pie -Os -fpic $OPTIMIZE_CFLAGS" \
    --extra-ldflags="-L/PublicData/openssl/openssl_1_1_1l/android/$ARCH/lib -L/PublicDataBackup/libx264/x264/android/$ARCH/lib $ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make -j10
make install
echo "The Compilation of FFmpeg for $CPU is completed"
cp $LIB_DIR/* /PublicData/ExternalStudioProjects/BIPPlayer/bipplayer/libs/$OUTPUT_FOLDER/
}

# armv8-a
OUTPUT_FOLDER="arm64-v8a"
ARCH=arm64
CPU="armv8-a"
TOOL_PREFIX="$TOOLCHAIN/bin/aarch64-linux-android"

CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
LIB_DIR="${PWD}/android/libs/$OUTPUT_FOLDER"
OPTIMIZE_CFLAGS="-march=$CPU"
build_android

# armv7-a
OUTPUT_FOLDER="armeabi-v7a"
ARCH=arm
CPU="armv7-a"
TOOL_PREFIX="$TOOLCHAIN/bin/armv7a-linux-androideabi"

CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
LIB_DIR="${PWD}/android/libs/$OUTPUT_FOLDER"
OPTIMIZE_CFLAGS="-march=$CPU"
build_android

# # x86_64
# OUTPUT_FOLDER="x86_64"
# ARCH="x86_64"
# CPU="x86-64"
# TOOL_CPU_NAME="x86_64"
# TOOL_PREFIX="$TOOLCHAIN/bin/${TOOL_CPU_NAME}-linux-android"

# CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
# LIB_DIR="${PWD}/android/libs/$OUTPUT_FOLDER"
# OPTIMIZE_CFLAGS="-march=$CPU"
# build_android