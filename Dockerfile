FROM ghcr.io/z-docker/android-ndk
LABEL maintainer="Zero <github.com/z-nerd>" 
LABEL description="Camellia-r-oss builder"

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman -Syu --noconfirm 

RUN sudo mkdir -p /opt/app/out && \
  sudo chmod -R 777 /opt/app

WORKDIR /opt/app

RUN git clone --depth=1 https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git -b camellia-r-oss camellia-r-oss && \
  pushd camellia-r-oss && \
  git clone --depth=1 https://github.com/z-kernel/gcc-aarch64-linux-android-4.9.git toolchain && \
  popd

RUN git clone --depth=1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 clang_toolchains
RUN git clone --depth=1 https://github.com/ArrowOS-Devices/proton-clang.git

ENV ANDROID_NDK /opt/android-ndk
ENV CLANG_TOOLCHAINS /opt/app/clang_toolchains/clang-r487747c/bin
ENV GCC_TOOLCHAINS /opt/app/camellia-r-oss/toolchain/bin
ENV PROTON_TOOLCHAINS /opt/app/proton-clang/bin

COPY entrypoint.sh .

ENTRYPOINT [ "/opt/app/entrypoint.sh" ]

