#!/bin/sh

yum -q -y update

# install build tools
yum -q -y install gcc g++ gcc-c++ make git bison flex openssl-devel

# install perl and dependencies
yum -q -y install perl perl-core perl-CPAN perl-Env

# make CPAN run without interaction
PERL_MM_USE_DEFAULT=1 PERL_EXTUTILS_AUTOINSTALL="--defaultdeps" perl -MCPAN -e'install Bundle::CPAN'

# install cpan- for even less interaction
cpan App::cpanminus

# install dependencies for driver tool perl script
/usr/local/bin/cpanm Cwd LWP::Protocol::https XML::LibXML
