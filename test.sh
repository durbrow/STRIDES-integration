#!/bin/sh
BACK=$PWD
cd $HOME
rm -rf .ncbi/user-settings.mkfg
vdb-config --set /libs/cloud/location=sra-ncbi.public /repository/remote/main/SDL.2/resolver-cgi=https://trace.ncbi.nlm.nih.gov/Traces/sdl/unstable/retrieve /repository/remote/version=130
cd $BACK

prefetch SRA000001
fastq-dump SRA000001
