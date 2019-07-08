#!/bin/bash

rm -rf ngs ncbi-vdb sra-tools ncbi-outdir

# get fresh repo's
git clone --branch engineering https://github.com/ncbi/ngs.git    
git clone https://github.com/ncbi/ncbi-vdb.git
git clone https://github.com/ncbi/sra-tools.git

cd ncbi-vdb
git fetch --all
git checkout engineering
git pull --all

echo "building engineering branch ..."
./configure >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "creating integration branch ..."
git checkout -b integration

echo "built integration branch in ncbi-vdb"
cd ..


echo "building ngs-sdk library ..."
cd ngs
./configure >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 -C ngs-sdk >/dev/null 2>&1 || { echo "make failed"; exit 1; }
cd ..


cd sra-tools
git fetch --all
git checkout VDB-3739
git checkout VDB-3786
git checkout VDB-3794
git checkout engineering
git pull --all

echo "building engineering branch ..."
./configure >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "creating integration branch ..."
git checkout -b integration

echo "merging and building VDB-3739 ..."
git merge --no-edit VDB-3739 || { echo "merge failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "merging and building VDB-3786 ..."
git merge --no-edit VDB-3786 || { echo "merge failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "merging and building VDB-3794 ..."
git merge --no-edit VDB-3794 || { echo "merge failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "built integration branch in sra-tools"
cd ..
