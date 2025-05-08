#!/bin/bash
# build_rootfs.sh - 全自动Ubuntu根文件系统构建工具
set -eo pipefail

# 配置参数
TAR_FILE="ubuntu-base-22.04-base-arm64.tar.gz"
ROOTFS_DIR="ubuntu_rootfs"
OUTPUT_IMG="test_ubuntu.ext4"
IMG_SIZE=1024  # MB
MIRROR_URL="http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/"

# 清理函数
cleanup() {
    echo ">> 执行清理..."
    sudo umount -lq "${ROOTFS_DIR}/proc" 2>/dev/null || true
    sudo umount -lq "${ROOTFS_DIR}/sys" 2>/dev/null || true
    sudo umount -lq "${ROOTFS_DIR}/dev/pts" 2>/dev/null || true
    sudo umount -lq "${ROOTFS_DIR}/dev" 2>/dev/null || true
    sudo umount -lq "${ROOTFS_DIR}" 2>/dev/null || true
    [ -d "${ROOTFS_DIR}" ] && sudo rm -rf "${ROOTFS_DIR}"
}
trap cleanup EXIT ERR

# 解压根文件系统
echo ">> 解压 ${TAR_FILE} 到 ${ROOTFS_DIR}"
mkdir -p "${ROOTFS_DIR}"
sudo tar -xpf "${TAR_FILE}" -C "${ROOTFS_DIR}" --checkpoint=.100

# 配置基础环境
echo ">> 配置基础环境"
sudo cp /etc/resolv.conf "${ROOTFS_DIR}/etc/"
sudo chmod 1777 "${ROOTFS_DIR}/tmp"

# 挂载虚拟文件系统
mount_fs() {
    echo ">> 挂载虚拟文件系统"
    sudo mount -t proc /proc "${ROOTFS_DIR}/proc"
    sudo mount -t sysfs /sys "${ROOTFS_DIR}/sys"
    sudo mount -o bind /dev "${ROOTFS_DIR}/dev"
    sudo mount -o bind /dev/pts "${ROOTFS_DIR}/dev/pts"
}

# 安装核心软件
install_packages() {
    echo ">> 在chroot环境中安装软件"
    sudo chroot "${ROOTFS_DIR}" /bin/bash <<'EOL'
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
    vim bash-completion net-tools iputils-ping \
    ifupdown ethtool ssh rsync udev htop rsyslog \
    nfs-common language-pack-en-base sudo psmisc
passwd root <<EOF
root
root
EOF
exit
EOL
}

# 执行挂载和安装
mount_fs
install_packages

# 创建磁盘镜像
echo ">> 创建${IMG_SIZE}MB磁盘镜像"
dd if=/dev/zero of="${OUTPUT_IMG}" bs=1M count="${IMG_SIZE}" status=progress
mkfs.ext4 -F "${OUTPUT_IMG}"

# 复制文件到镜像
echo ">> 复制文件到镜像"
mkdir -p mnt
sudo mount "${OUTPUT_IMG}" mnt
# sudo cp -rfp "${ROOTFS_DIR}"/* mnt/
# sudo rsync -a --exclude=/proc "${ROOTFS_DIR}"/* mnt/
sudo rsync -av --delete --exclude=/sys --exclude=/proc --exclude=/dev "${ROOTFS_DIR}"/* mnt/
sudo umount mnt

# 优化镜像
echo ">> 优化镜像文件系统"
e2fsck -p -f "${OUTPUT_IMG}"

echo ">> 构建完成！镜像文件：${OUTPUT_IMG}"