# QEMU := sudo qemu-system-aarch64
QEMU := sudo /root/qemu-9.2.0/build/qemu-system-aarch64

UBOOT := $(image_dir)/bootloader/u-boot-atf.bin

FSIMG1 := $(image_dir)/virtdisk/rootfs1.ext4
FSIMG2 := $(image_dir)/virtdisk/rootfs2.ext4

zone0_kernel := $(image_dir)/kernel/Image
zone1_kernel := $(image_dir)/kernel/Image
zone0_dtb    := $(image_dir)/devicetree/linux1.dtb
zone1_dtb    := $(image_dir)/devicetree/linux2.dtb

QEMU_ARGS := -machine virt,secure=on,gic-version=3,virtualization=on,iommu=smmuv3
QEMU_ARGS += -global arm-smmuv3.stage=2

# QEMU_ARGS += -d int

QEMU_ARGS += -cpu cortex-a57
QEMU_ARGS += -smp $(CONFIG_CPU_COUNT)
QEMU_ARGS += -m $(CONFIG_MEMORY_SIZE)G
QEMU_ARGS += -nographic
QEMU_ARGS += -bios $(UBOOT)

QEMU_ARGS += -device loader,file="$(hvisor_bin)",addr=0x40400000,force-raw=on

include .config

ifeq ($(CONFIG_VM_COUNT_1),y)
QEMU_ARGS += -device loader,file="$(zone0_kernel)",addr=0xa0400000,force-raw=on
QEMU_ARGS += -device loader,file="$(zone0_dtb)",addr=0xa0000000,force-raw=on
endif

ifeq ($(CONFIG_VM_COUNT_2),y)
QEMU_ARGS += -device loader,file="$(zone0_kernel)",addr=0xa0400000,force-raw=on
QEMU_ARGS += -device loader,file="$(zone0_dtb)",addr=0xa0000000,force-raw=on
QEMU_ARGS += -device loader,file="$(zone1_kernel)",addr=0x70000000,force-raw=on
QEMU_ARGS += -device loader,file="$(zone1_dtb)",addr=0x91000000,force-raw=on
endif

ifeq ($(CONFIG_VM_COUNT_3),y)
endif


ifeq ($(CONFIG_VIRTIO_BLK),y)
    QEMU_ARGS += -drive if=none,file=$(FSIMG1),id=Xa003e000,format=raw
    QEMU_ARGS += -device virtio-blk-device,drive=Xa003e000,bus=virtio-mmio-bus.31
endif


ifeq ($(CONFIG_EXTRA_VIRTIO_BLK),y)
    QEMU_ARGS += -drive if=none,file=$(FSIMG2),id=Xa003c000,format=raw
    QEMU_ARGS += -device virtio-blk-device,drive=Xa003c000
endif


ifeq ($(CONFIG_NETWORK_TAP),y)
    QEMU_ARGS += -netdev tap,id=Xa003a000,ifname=tap0,script=no,downscript=no
    QEMU_ARGS += -device virtio-net-device,netdev=Xa003a000,mac=52:55:00:d1:55:01
endif


ifeq ($(CONFIG_NETWORK_USER),y)
    QEMU_ARGS += -netdev user,id=n0,hostfwd=tcp::5555-:22
    QEMU_ARGS += -device virtio-net-device,bus=virtio-mmio-bus.29,netdev=n0
endif


ifeq ($(CONFIG_VIRTIO_CONSOLE),y)
    QEMU_ARGS += -chardev pty,id=Xa0038000
    QEMU_ARGS += -device virtio-serial-device,bus=virtio-mmio-bus.28 -device virtconsole,chardev=Xa0038000
endif


ifeq ($(CONFIG_VIRTIO_9P),y)
    QEMU_ARGS += --fsdev local,id=Xa0036000,path=./9p/,security_model=none
    QEMU_ARGS += -device virtio-9p-pci,fsdev=Xa0036000,mount_tag=kmod_mount
endif


ifeq ($(CONFIG_TRACE_EVENTS),y)
    # trace-event gicv3_icc_generate_sgi on
    # trace-event gicv3_redist_send_sgi on
	QEMU_ARGS += -trace enable=gicv3_icc_generate_sgi,enable=gicv3_redist_send_sgi
endif


ifeq ($(CONFIG_VIRTIO_NET),y)
    QEMU_ARGS += -netdev type=user,id=net1
    QEMU_ARGS += -device virtio-net-pci,netdev=net1,disable-legacy=on,disable-modern=off,iommu_platform=on
endif


ifeq ($(CONFIG_PCI_TESTDEV),y)
    QEMU_ARGS += -device pci-testdev
endif


ifeq ($(CONFIG_NETWORK_USER_NET2),y)
    QEMU_ARGS += -netdev type=user,id=net2
    QEMU_ARGS += -device virtio-net-pci,netdev=net2,disable-legacy=on,disable-modern=off,iommu_platform=on
endif


ifeq ($(CONFIG_NETWORK_USER_NET3),y)
    QEMU_ARGS += -netdev type=user,id=net3
    QEMU_ARGS += -device virtio-net-pci,netdev=net3,disable-legacy=on,disable-modern=off,iommu_platform=on
endif


$(hvisor_bin): elf
	#@if ! command -v mkimage > /dev/null; then \
	#	sudo apt update && sudo apt install u-boot-tools; \
	#fi 
	rust-objcopy $(hvisor_elf) --strip-all -O binary $(hvisor_bin).tmp && \
	mkimage -n hvisor_img -A arm64 -O linux -C none -T kernel -a 0x40400000 \
	-e 0x40400000 -d $(hvisor_bin).tmp $(hvisor_bin) && \
	rm -rf $(hvisor_bin).tmp
