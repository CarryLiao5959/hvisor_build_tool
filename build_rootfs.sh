#!/bin/bash

set -e  # 任何命令失败则终止脚本

# -------------------- 缓存目录配置 --------------------
CACHE_DIR="${HOME}/.cache/rootfs_builder"     # 缓存目录
UBUNTU_BASE_CACHE="${CACHE_DIR}/ubuntu-base"  # Ubuntu基础包缓存
APT_CACHE_DIR="${CACHE_DIR}/apt"              # APT软件包缓存

# -------------------- 可配置参数项 --------------------
UBUNTU_VERSION="22.04"          # Ubuntu 版本
ARCH="arm64"                    # 目标架构
ROOTFS_IMG="ubuntu.img"         # 输出镜像文件名
IMG_SIZE="1G"                   # 镜像大小
USE_CACHE=1                     # 是否启用缓存
ENABLE_USER_CONFIG=0            # 是否添加用户和主机配置

# -------------------- 安装包配置项 --------------------
DEFAULT_PACKAGES="git sudo vim" # 默认安装包
PKG_LIST_FILE=""                # 外部软件包列表文件（每行一个包名）
ADD_PACKAGES=""                 # 新增软件包（逗号分隔）
REMOVE_PACKAGES=""              # 待卸载软件包（逗号分隔）

# -------------------- 参数选项解析 --------------------
usage() {
    echo "用法: $0 [选项]"
    echo "  -c          创建新镜像（默认模式）"
    echo "  -m <路径>   挂载现有镜像进行修改"
    echo "  -p <文件>   指定软件包列表文件"
    echo "  -a <包列表> 添加新软件包（逗号分隔）"
    echo "  -r <包列表> 卸载软件包（逗号分隔）"
    exit 1
}

while getopts "cm:p:a:r:" opt; do
    case $opt in
        c) MODE="create" ;;
        m) MODE="modify"; ROOTFS_IMG="$OPTARG" ;;
        p) PKG_LIST_FILE="$OPTARG" ;;
        a) ADD_PACKAGES="${OPTARG//,/ }" ;;
        r) REMOVE_PACKAGES="${OPTARG//,/ }" ;;
        *) usage ;;
    esac
done

# -------------------- 检查依赖安装 --------------------
install_dependencies() {
    local required=(debootstrap qemu-user-static parted)
    for cmd in "${required[@]}"; do
        if ! command -v "$cmd" &>/dev/null; then
            sudo apt-get install -y "$cmd"
        fi
    done
    sudo update-binfmts --enable qemu-aarch64
}

# -------------------- 构建缓存目录 --------------------
init_cache() {
    [ "$USE_CACHE" -eq 1 ] && {
        mkdir -p "$UBUNTU_BASE_CACHE" "$APT_CACHE_DIR"
        echo "🔍 使用缓存目录: $CACHE_DIR"
    }
}

# -------------------- 加速磁盘操作 --------------------
create_virtual_disk() {
    dd if=/dev/zero of="$ROOTFS_IMG" bs=1M count=$((${IMG_SIZE%G}*1024)) oflag=direct conv=fsync status=progress
    mkfs.ext4 "$ROOTFS_IMG"
    mkdir -p rootfs
    sudo mount -o loop "$ROOTFS_IMG" rootfs
}

# -------------------- 带缓存的下载 --------------------
cached_download() {
    local url="$1" filename="$2"
    local cache_path="${UBUNTU_BASE_CACHE}/${filename}"
    
    [ -f "$cache_path" ] && {
        echo "使用缓存文件: $cache_path"
        if ! tar tf "$cache_path" &>/dev/null; then
            echo "缓存文件损坏，重新下载..."
            rm "$cache_path"
        else
            cp "$cache_path" .
            return
        fi
    }
    
    wget -q "$url" -O "$filename"
    cp "$filename" "$cache_path"
}

# -------------------- 挂载系统目录 --------------------
mount_system_dirs() {
    QEMU_PATH=$(which qemu-aarch64-static)
    [ -z "$QEMU_PATH" ] && { echo "qemu-aarch64-static未安装"; exit 1; }
    sudo cp "$QEMU_PATH" rootfs/usr/bin/
    sudo mount -t proc /proc rootfs/proc
    sudo mount -t sysfs /sys rootfs/sys
    sudo mount -o bind /dev rootfs/dev
    sudo mount -o bind /dev/pts rootfs/dev/pts
    sudo cp /etc/resolv.conf rootfs/etc/resolv.conf
    sudo cp /usr/bin/qemu-aarch64-static rootfs/usr/bin/
}

# -------------------- 挂载现有镜像 --------------------
mount_existing_rootfs() {
    [ ! -f "$ROOTFS_IMG" ] && { echo "镜像文件不存在"; exit 1; }
    mkdir -p rootfs
    sudo mount -o loop "$ROOTFS_IMG" rootfs
    mount_system_dirs
}

# -------------------- 加载软件包配置 --------------------
load_packages() {
    local base_pkgs="ubuntu-standard systemd-sysv"
    [[ -f "$PKG_LIST_FILE" ]] && DEFAULT_PACKAGES+=" $(tr '\n' ' ' < "$PKG_LIST_FILE")"
    echo "$base_pkgs $EXTRA_PACKAGES $ADD_PACKAGES" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

# -------------------- 用户配置函数 --------------------
configure_user() {
    sudo chroot rootfs /bin/bash <<EOF
    adduser --gecos "" arm64
    echo "arm64:arm64" | chpasswd
    adduser arm64 sudo
    echo "kernel-5_4" > /etc/hostname
    echo "127.0.0.1 localhost kernel-5_4" >> /etc/hosts
    dpkg-reconfigure -f noninteractive tzdata
EOF
}

# -------------------- 构建根文件系统核心 --------------------
build_rootfs() {
    local install_pkgs=$(load_packages)
    
    sudo chroot rootfs /bin/bash <<EOF

    apt-get install -y locales
    echo "LANG=en_US.UTF-8" > /etc/default/locale
    echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen zh_CN.UTF-8
    update-locale LANG=en_US.UTF-8 LC_ALL=zh_CN.UTF-8
    apt-get install -y rsync

    mkdir -p /var/cache/apt/archives
    rm -rf /var/lib/apt/lists/*
    [ "$USE_CACHE" -eq 1 ] && {
        rsync -a "${APT_CACHE_DIR}/" /var/cache/apt/archives/
        apt-get update --allow-insecure-repositories
    }

    apt-get -o APT::Install-Recommends=false \
            -o APT::Get::Assume-Yes=true \
            -o Dpkg::Options::="--force-confdef" \
            -o Dpkg::Options::="--force-confold" \
            -o Dpkg::Use-Pty=0 \
            install -y $install_pkgs

    [ -n "$REMOVE_PACKAGES" ] && apt-get purge -y $REMOVE_PACKAGES
    apt-get autoremove -y
    apt-get clean

    [ "$USE_CACHE" -eq 1 ] && rsync -a /var/cache/apt/archives/ "${APT_CACHE_DIR}/"
EOF

    if [ "$ENABLE_USER_CONFIG" -eq 1 ]; then
        configure_user
    fi
}

# -------------------- 卸载与清理 --------------------
unmount_rootfs() {
    sudo umount rootfs/proc rootfs/sys rootfs/dev/pts rootfs/dev 2>/dev/null
    sudo umount rootfs || { echo "强制卸载..."; sudo umount -l rootfs; }
    sleep 1 && sudo rm -rf rootfs
}

# -------------------- 主执行流程 --------------------
main() {
    install_dependencies
    init_cache
    
    case "${MODE:-create}" in
        "create")
            create_virtual_disk
            cached_download \
                "http://cdimage.ubuntu.com/ubuntu-base/releases/${UBUNTU_VERSION}/release/ubuntu-base-${UBUNTU_VERSION}-base-${ARCH}.tar.gz" \
                "ubuntu-base-${UBUNTU_VERSION}-base-${ARCH}.tar.gz"
            sudo tar -I pigz -xf "ubuntu-base-${UBUNTU_VERSION}-base-${ARCH}.tar.gz" -C rootfs
            mount_system_dirs
            build_rootfs
            ;;
        "modify")
            mount_existing_rootfs
            build_rootfs
            ;;
    esac
    
    unmount_rootfs
    echo "✅ 操作完成! 镜像文件: $(realpath $ROOTFS_IMG)"
}

main "$@"