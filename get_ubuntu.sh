#!/bin/bash
# 多架构下载脚本

arch=$1
url=""

# 架构匹配
case $arch in
    arm64) url="http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz" ;;
    riscv) url="http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.2-base-riscv64.tar.gz" ;;
    nxp)   url="http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.5-base-arm64.tar.gz" ;;
    *) echo "用法: $0 [arm64|riscv|nxp]"; exit 1 ;;
esac

filename=$(basename "$url")

# 文件存在性检查
if [ -f "$filename" ]; then
    echo "检测到已存在文件: $filename，跳过下载"
    exit 0
fi

# 执行下载
echo "开始下载 $arch 架构镜像..."
wget --show-progress -qO "$filename" "$url" && \
echo "下载完成！文件名: $filename"