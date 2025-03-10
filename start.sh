sudo apt-get update
sudo apt-get install chrpath diffstat gawk
# linux
sudo apt-get install python3-distutils
sudo apt-get install chrpath gawk texinfo
sudo apt-get install build-essential
# ruxos
sudo apt-get install clang libclang-dev
# hvisor
sudo apt-get install u-boot-tools

mkdir ./toolchain

wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
tar xvf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz -C ./toolchain

wget https://musl.cc/x86_64-linux-musl-cross.tgz

tar xvf x86_64-linux-musl-cross.tgz -C ./toolchain
