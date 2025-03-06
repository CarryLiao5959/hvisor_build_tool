git submodule init
git submodule update

cd meta-openembedde
git checkout dunfell
cd ../

cd meta-arm
git checkout dunfell
cd ../
tar cvzf hvisor.tar.gz hvisor
sh ./oe-init-build-env
bitbake hvisor
