SUMMARY = "Custom Linux Kernel 5.4"
DESCRIPTION = "Custom Linux Kernel for development and testing"
LICENSE = "GPL-2.0-only"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

inherit kernel

LINUX_VERSION = "5.4"
PR = "r0"

# 指定源码的 URI
SRC_URI = "file://${HOME}/hvisor_build_tool/linux-5.4.tar.gz"

# 配置文件和补丁
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://defconfig"

# 配置兼容的目标机器
COMPATIBLE_MACHINE = "(qemuarm|qemux86|qemumips)"

# 设置源码目录
S = "${WORKDIR}/linux-5.4"

