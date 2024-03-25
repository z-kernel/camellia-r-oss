FROM ghcr.io/z-docker/archlinux:multilib
LABEL maintainer="Zero <github.com/z-nerd>" 
LABEL description="Camellia-r-oss builder"

RUN sudo pacman-key --init && \
  sudo pacman-key --populate archlinux && \
  sudo pacman -Syu --noconfirm && \
  yes | sudo pacman -Scc

RUN sudo mkdir -p /opt/build/tools && \
  sudo chmod -R 777 /opt/build
WORKDIR /opt/build

RUN pushd tools && \
  wget https://android.googlesource.com/platform//prebuilts/clang/host/linux-x86/+archive/3857008389202edac32d57008bb8c99d2c957f9d/clang-r383902.tar.gz && \ 
  mkdir clang-r383902 && tar -vxf clang-r383902.tar.gz -C clang-r383902 && \
  rm clang-r383902.tar.gz && \
  popd
ENV CLANG_TOOLCHAINS /opt/build/tools/clang-r383902/bin

RUN pushd tools && \
  git clone --depth=1 https://android.googlesource.com/platform/prebuilts/build-tools build-tools && \
  popd
ENV BUILDTOOLS_TOOLCHAINS /opt/build/tools/build-tools

RUN pushd tools && \
  git clone --depth=1 https://github.com/z-kernel/gcc-aarch64-linux-android-4.9.git gcc && \
  popd
ENV GCC_TOOLCHAINS /opt/build/tools/gcc/bin

RUN git clone --depth=1 https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git -b camellia-r-oss kernel && \
  pushd kernel && \
  git fetch --depth=1 origin 4b6c276ac99cad51bf4d0bd6ea12a32847403b42 && \
  git checkout 4b6c276ac99cad51bf4d0bd6ea12a32847403b42 && \
  git branch -D @{-1} && \
  popd
ENV KERNEL_SRC /opt/build/kernel

COPY entrypoint.sh .

ENTRYPOINT [ "/opt/build/entrypoint.sh" ]

