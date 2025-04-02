# image & rootfs generator for hvisor

## Support

1. hvisor binary
2. linux image (for zone0)
3. ruxos image
4. ubuntu rootfs

> env for QEMU

## How to Run

### init env & download deps

use devel branch, then execute command:

```
sh build_start.sh
```

### build

- **build hvisor binary**
    
    ```
    sh build_hvisor.sh
    ```
    
    > binary path: /home/yocto/hvisor_ build_tool/build/tmp/work/core2-64-poky-linux/hvisor/0.1-r0/target/aarch64-unknown-none/debug/

- **build linux image**
    
    ```
    sh build_linux.sh
    ```
    
    > image path: /home/yocto/hvisor_ build_tool/build/tmp/work/qemuarm64-poky-linux/linux-custom/1.0-r0/deploy-linux-custom/

- **build ruxos image**
    
    ```
    sh build_ruxos.sh
    ```
    
    > image path: /home/yocto/hvisor_ build_tool/build/tmp/work/core2-64-poky-linux/ruxos/0.1-r0/ruxos/apps/helloworld/

- **build rootfs image**
    
    default cmd
    ```
    sh build_rootfs.sh
    ```

    create image & choose package to install
    ```
    ./build_rootfs.sh -c -p pkglist.txt 
    ```

    modify existing image & add/remove package
    ```
    ./build_rootfs.sh -m ubuntu.img -a "docker.io,gcc" -r "vim"
    ```
    
    > rootfs path: ./ubuntu-base-22.04-base-arm64.tar.gz
& ./ubuntu.img

