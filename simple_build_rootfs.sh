#!/bin/bash
# build_rootfs_strict.sh - 严格遵循原始流程的构建脚本

set -e

ARCH_TYPE="$1"

# 硬编码参数
QEMU_SRC_PATH="$HOME/qemu-9.1.0-rc4/build/qemu-system-aarch64"
ROOTFS_DIR="rootfs"
OUTPUT_IMG="rootfs_simple.img"

# 架构URL映射
case $ARCH_TYPE in
    arm64) 
        URL="http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz"
        ;;
    riscv) 
        URL="http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.2-base-riscv64.tar.gz" 
        ;;
    nxp)   
        URL="http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz"
        ;;
    *) 
        echo "用法: $0 [arm64|riscv|nxp]" 
        exit 1
        ;;
esac

TAR_FILE=$(basename "$URL")

# # 在清理阶段添加强制卸载逻辑
# sudo umount -lf $ROOTFS_DIR/proc 2>/dev/null
# sudo umount -lf $ROOTFS_DIR/sys 2>/dev/null
# sudo umount -lf $ROOTFS_DIR/dev/pts 2>/dev/null
# sudo umount -lf $ROOTFS_DIR/dev 2>/dev/null
# sudo umount -lf $ROOTFS_DIR 2>/dev/null
# # 清理旧文件
# [ -d $ROOTFS_DIR ] && sudo rm -rf $ROOTFS_DIR
# [ -f $OUTPUT_IMG ] && sudo rm -f $OUTPUT_IMG

# 下载基础包
if [ ! -f "$TAR_FILE" ]; then
    echo "下载 $ARCH_TYPE 架构基础包..."
    wget --show-progress -qO "$TAR_FILE" "$URL"
else
    echo "检测到已存在基础包: $TAR_FILE，跳过下载"
fi

# 创建磁盘镜像
echo "创建1GB磁盘镜像..."
dd if=/dev/zero of=$OUTPUT_IMG bs=1M count=1024 oflag=direct
mkfs.ext4 $OUTPUT_IMG

# 挂载镜像
mkdir -p $ROOTFS_DIR
sudo mount -t ext4 $OUTPUT_IMG $ROOTFS_DIR

# 解压基础系统
echo "解压Ubuntu base系统..."
sudo tar -xzf $TAR_FILE -C $ROOTFS_DIR

# 配置QEMU环境
echo "安装QEMU依赖..."
sudo apt-get install -y qemu-user-static > /dev/null
sudo cp $QEMU_SRC_PATH $ROOTFS_DIR/usr/bin/
sudo cp /usr/bin/qemu-aarch64-static $ROOTFS_DIR/usr/bin/
sudo update-binfmts --enable qemu-aarch64

# 基础配置
sudo cp /etc/resolv.conf $ROOTFS_DIR/etc/

# 挂载虚拟文件系统
echo "挂载虚拟文件系统..."
sudo mount -t proc /proc $ROOTFS_DIR/proc
sudo mount -t sysfs /sys $ROOTFS_DIR/sys
sudo mount -o bind /dev $ROOTFS_DIR/dev
sudo mount -o bind /dev/pts $ROOTFS_DIR/dev/pts

# 软件包安装
echo "开始安装核心软件..."
sudo chroot $ROOTFS_DIR /bin/bash <<'EOL'
apt-get update
apt-get install -y --no-install-recommends \
    git sudo vim bash-completion kmod \
    net-tools iputils-ping resolvconf ntpdate screen
apt-get clean
rm -rf /var/lib/apt/lists/*
exit
EOL

# 卸载挂载点
echo "清理挂载..."
sudo umount $ROOTFS_DIR/proc
sudo umount $ROOTFS_DIR/sys
sudo umount $ROOTFS_DIR/dev/pts
sudo umount $ROOTFS_DIR/dev
sudo umount $ROOTFS_DIR
rmdir $ROOTFS_DIR

echo "构建完成！输出镜像: $OUTPUT_IMG"