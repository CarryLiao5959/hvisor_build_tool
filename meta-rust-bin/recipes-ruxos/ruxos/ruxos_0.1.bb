SUMMARY = "hvisor - A lightweight Rust-based Hypervisor"
DESCRIPTION = "hvisor is a hypervisor written in Rust, supporting ARM (aarch64) and RISC-V architectures."
HOMEPAGE = "https://github.com/syswonder/ruxos.git"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://README.md;md5=b5ac5f5dbe3dd7963aca781b94d98fc5"

# Git 获取源码
#SRC_URI = "git://github.com/syswonder/hvisor.git;branch=main;protocol=https"
#SRCREV = "05c2c774ae143ba0a458ffb1d8e53b23adc61ce9"
SRC_URI = "file:///${HOME}/hvisor_build_tool/ruxos.tar.gz"

S = "${WORKDIR}/ruxos"

# 继承 cargo 构建规则
inherit cargo_bin

# Rust 交叉编译目标架构
# 根据 Yocto 的 MACHINE 自动切换架构
# aarch64 和 riscv64 是 hvisor 已支持的架构
# RUST_ARCH = "${@'aarch64-unknown-none' if d.getVar('TARGET_ARCH') == 'aarch64' else 'riscv64gc-unknown-none-elf'}"
CARGO_BUILD_PROFILE = "dev"
# 指定构建目标架构
#CARGO_BUILD_TARGET = "${RUST_ARCH}"
RUST_TARGET = "x86_64-unknown-none"

# 如果需要指定 Rust 的版本，可以这样设置（可选）
PREFERRED_VERSION_rust = "nightly-2023-12-28"

# Rust 编译依赖（一般 cargo 会处理依赖，但如果需要额外依赖可以写在这里）
#DEPENDS += "rust"
#DEPENDS += "rust-bin-cross-x86_64 cargo-bin-cross-x86_64"


# 定义 Cargo 构建参数
#CARGO_FEATURES += "platform_qemu"
EXTRA_CARGO_FLAGS += "-Z build-std=core,alloc"
EXTRA_CARGO_FLAGS += "-Z build-std-features=compiler-builtins-mem"
EXTRA_CARGO_FLAGS += "-p ruxlibc --features 'ruxfeat/log-level-warn ruxfeat/bus-pci'"

#export RUSTFLAGS="-Clink-args=-Tscripts/qemu-aarch64.ld"
export LD_LIBRARY_PATH="${WORKDIR}/target/aarch64-unknown-none/debug/deps/:${WORKDIR}/recipe-sysroot-native/usr/lib"

# 构建模式: 默认 debug，切换为 release 时可以使用 bitbake -c build hvisor -f
#EXTRA_OECARGO_BUILD_ARGS += "--release"

#do_compile[network] = "1"

do_compile_append() {
    echo "Running makefile after cargo build"
    # 调用项目中的 Makefile
    echo "===> do compile path  ${S}"
    export PATH=$PATH:/usr/bin/:${WORKDIR}/recipe-sysroot-native/usr/lib/rustlib/x86_64-unknown-linux-gnu/bin/:${HOME}/hvisor_build_tool/toolchain/x86_64-linux-musl-cross/bin/
    cp ${WORKDIR}/recipe-sysroot-native/usr/lib/rustlib/x86_64-unknown-linux-gnu/bin/llvm-objcopy ${WORKDIR}/recipe-sysroot-native/usr/lib/rustlib/x86_64-unknown-linux-gnu/bin/rust-objcopy
    #cp ${S}/target ${S}/ -ar
    pwd
    cd ${S}/
    make A=apps/c/helloworld
}

# 安装编译后的二进制文件
do_install() {
	:
}


