#!/bin/bash

git submodule init
git submodule update

cd meta-openembedded
git checkout dunfell
cd ../

cd meta-arm
git checkout dunfell
cd ../
tar cvzf hvisor.tar.gz hvisor

. ./oe-init-build-env

cd ../
cp backup/hvisor_conf/* build/conf/ -ar

bitbake hvisor
