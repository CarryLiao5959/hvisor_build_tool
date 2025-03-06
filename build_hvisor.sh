git submodule init
git submodule update

cd meta-
git checkout dunfell
cd ../meta-openembedded

cd meta-arm
git checkout dunfell
cd ../
tar cvzf hvisor.tar.gz hvisor
sh ./oe-init-build-env
bitbake hvisor
