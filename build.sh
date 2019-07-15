#!/bin/bash
CONFIGURE="./configure --without-debug"
rm -rf ngs ncbi-vdb sra-tools ncbi-outdir

# get fresh repo's
git clone --branch engineering --depth 1 https://github.com/ncbi/ngs.git
git clone --branch engineering --depth 1 https://github.com/ncbi/ncbi-vdb.git
git clone --branch engineering --depth 1 https://github.com/ncbi/sra-tools.git

cd ncbi-vdb

echo "building engineering branch ..."
${CONFIGURE} >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "built engineering branch in ncbi-vdb"
cd ..


echo "building ngs-sdk library ..."
cd ngs
${CONFIGURE} >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 -C ngs-sdk >/dev/null 2>&1 || { echo "make failed"; exit 1; }
cd ..


cd sra-tools

echo "building engineering branch ..."
${CONFIGURE} >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "built engineering branch in sra-tools"
echo "installing..."
sudo rm -rf /etc/ncbi /etc/profile.d/sra-tools.* /usr/local/ncbi
sudo make install
cd ..
rm -rf ngs ncbi-vdb sra-tools ncbi-outdir .ncbi SRR* ERR* DRR*
