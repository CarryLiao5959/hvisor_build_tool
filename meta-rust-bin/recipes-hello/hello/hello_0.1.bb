SUMMARY = "hello - A lightweight Rust-based hello"
DESCRIPTION = "hello is a hypervisor written in Rust, supporting ARM (aarch64) and RISC-V architectures."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://README.md;md5=905f946d3f5d7ada9a8b52cc329e3e7c"

# Git 获取源码
#SRC_URI = "git://github.com/syswonder/hvisor.git;branch=main;protocol=https"
#SRCREV = "05c2c774ae143ba0a458ffb1d8e53b23adc61ce9"
SRC_URI = "file:///opt/hello_rust.tar.gz"

S = "${WORKDIR}/hello_rust"

# 继承 cargo 构建规则
inherit cargo_bin

# Rust 交叉编译目标架构
# 根据 Yocto 的 MACHINE 自动切换架构
# aarch64 和 riscv64 是 hvisor 已支持的架构
# RUST_ARCH = "${@'aarch64-unknown-none' if d.getVar('TARGET_ARCH') == 'aarch64' else 'riscv64gc-unknown-none-elf'}"

# 指定构建目标架构
#CARGO_BUILD_TARGET = "${RUST_ARCH}"
#RUST_TARGET = "aarch64-unknown-none"

# 如果需要指定 Rust 的版本，可以这样设置（可选）
PREFERRED_VERSION_rust = "nightly-2023-12-28"

# Rust 编译依赖（一般 cargo 会处理依赖，但如果需要额外依赖可以写在这里）
#DEPENDS += "rust"
#DEPENDS += "rust-bin-cross-x86_64 cargo-bin-cross-x86_64"


# 定义 Cargo 构建参数
#CARGO_FEATURES += "platform_imx8mp"
#EXTRA_CARGO_FLAGS += "-Z build-std=core,alloc"
#EXTRA_CARGO_FLAGS += "-Z build-std-features=compiler-builtins-mem"


# 构建模式: 默认 debug，切换为 release 时可以使用 bitbake -c build hvisor -f
#EXTRA_OECARGO_BUILD_ARGS += "--release"

do_compile[network] = "1"

do_install() {
	:
}
