# clean up any old installation
rm -rf /usr/local/ncbi /etc/ncbi

echo "installing sra-tools to default location"
cd sra-tools
make install
# copy driver tool (normally would be done by installer script)
cp tools/driver-tool/sratools.pl /usr/local/ncbi/sra-tools/bin/
cd ..

# clean up build artifacts
rm -rf ngs ncbi-vdb sra-tools ncbi-outdir


# setup links (normally would be done by installer script)
BACK=$PWD
cd /usr/local/ncbi/sra-tools/bin/

ln -s sratools.pl sratools

mv fasterq-dump.2.10.0 fasterq-dump-orig
ln -s sratools fasterq-dump.2.10.0

mv fastq-dump.2.10.0 fastq-dump-orig
ln -s sratools fastq-dump.2.10.0

mv prefetch.2.10.0 prefetch-orig
ln -s sratools prefetch.2.10.0

mv sam-dump.2.10.0 sam-dump-orig
ln -s sratools sam-dump.2.10.0

mv srapath.2.10.0 srapath-orig
ln -s sratools srapath.2.10.0

mv sra-pileup.2.10.0 sra-pileup-orig
ln -s sratools sra-pileup.2.10.0

cd $BACK
