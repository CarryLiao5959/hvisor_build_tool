#!/bin/bash
set -e  # 任何命令失败则终止脚本

# -------------------- 用户可配置参数 --------------------
UBUNTU_VERSION="22.04"      # Ubuntu 版本 (20.04/22.04)
ARCH="arm64"                # 目标架构 (arm64/armhf)
ROOTFS_IMG="ubuntu.img"     # 输出镜像文件名
IMG_SIZE="2G"               # 镜像大小 (默认2G)
EXTRA_PACKAGES="git sudo vim bash-completion kmod net-tools iputils-ping resolvconf ntpdate screen"  # 需安装的额外软件包[1](@ref)
ENABLE_USER_CONFIG=1        # 是否添加用户和主机配置 (0=禁用,1=启用)

# -------------------- 依赖检查与安装 --------------------
install_dependencies() {
    local required=(debootstrap qemu-user-static parted)
    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            sudo apt-get install -y "$cmd"
        fi
    done
    sudo update-binfmts --enable qemu-aarch64  # 解决chroot架构问题[1](@ref)
}

# -------------------- 创建并挂载虚拟磁盘 --------------------
create_virtual_disk() {
    dd if=/dev/zero of="$ROOTFS_IMG" bs=1M count=$((${IMG_SIZE%G}*1024)) oflag=direct
    mkfs.ext4 "$ROOTFS_IMG"
    mkdir -p rootfs
    sudo mount -o loop "$ROOTFS_IMG" rootfs
}

# -------------------- 构建根文件系统 --------------------
build_rootfs() {
    # 下载和解压 Ubuntu Base
    wget -q "http://cdimage.ubuntu.com/ubuntu-base/releases/${UBUNTU_VERSION}/release/ubuntu-base-${UBUNTU_VERSION}-base-${ARCH}.tar.gz"
    sudo tar -xzf "ubuntu-base-${UBUNTU_VERSION}-base-${ARCH}.tar.gz" -C rootfs

    # 挂载系统目录
    sudo mount -t proc /proc rootfs/proc
    sudo mount -t sysfs /sys rootfs/sys
    sudo mount -o bind /dev rootfs/dev
    sudo mount -o bind /dev/pts rootfs/dev/pts

    # 基础配置
    sudo cp /etc/resolv.conf rootfs/etc/resolv.conf
    sudo cp /usr/bin/qemu-aarch64-static rootfs/usr/bin/

    # 安装软件包
    sudo chroot rootfs /bin/bash <<EOF
apt-get update
apt-get install -y ubuntu-standard systemd-sysv $EXTRA_PACKAGES
apt-get clean
EOF

    # 可选用户配置
    if [ "$ENABLE_USER_CONFIG" -eq 1 ]; then
        sudo chroot rootfs /bin/bash <<EOF
adduser --gecos "" arm64
echo "arm64:arm64" | chpasswd
adduser arm64 sudo
echo "kernel-5_4" > /etc/hostname
echo "127.0.0.1 localhost kernel-5_4" >> /etc/hosts
dpkg-reconfigure -f noninteractive tzdata
EOF
    fi

    # 清理与卸载
    sudo umount rootfs/proc rootfs/sys rootfs/dev/pts rootfs/dev
    sudo umount rootfs
    rm -rf rootfs
}

# -------------------- 主执行流程 --------------------
main() {
    install_dependencies
    create_virtual_disk
    build_rootfs
    echo "✅ 根文件系统构建完成! 镜像文件: $(realpath $ROOTFS_IMG)"
}

main "$@"