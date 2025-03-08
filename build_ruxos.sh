#!/bin/bash

git submodule init
git submodule update

cd meta-arm
git checkout dunfell
cd ../

cd ruxos
git apply ../patch/0001-fix-compile-rust-ztd.patch
cd ../

tar cvzf ruxos.tar.gz ruxos

. ./oe-init-build-env

cd ../
cp backup/hvisor_conf/* build/conf/ -ar

bitbake -vv ruxos
