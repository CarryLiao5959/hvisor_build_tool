git submodule init
git submodule update

cd linux-5.4
git checkout v5.4
cd ../
cd meta-arm
git checkout dunfell
cd ../
cd linux-5.4
git apply ../patch/0001-fix-compile-multiple-definition-of-yylloc.patch
cd ../
tar cvzf linux-5.4.tar.gz linux-5.4
sh ./oe-init-build-env
bitbake linux-custom
