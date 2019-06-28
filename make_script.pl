#!/usr/bin/perl -w

use warnings;
use strict;

sub do_repo($@)
{
    my ($repo, @branches) = @_;
    print <<"END";
cd $repo
git fetch --all
END
    print "git checkout $_\n" for @branches;
    print <<"END";
git checkout engineering
git pull --all

echo "building engineering branch ..."
./configure >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 clean default >/dev/null 2>&1 || { echo "make failed"; exit 1; }

echo "creating integration branch ..."
git checkout -b integration

END
    for (@branches) {
        print <<"END";
echo "merging and building $_ ..."
git merge $_ || { echo "merge failed"; exit 1; }
make -sj1 >/dev/null 2>&1 || { echo "make failed"; exit 1; }

END
    }
    print <<"END";
echo "built integration branch in $repo"
cd ..


END
}

do_repo 'ncbi-vdb', qw{
    VDB-3817
};
#    VDB-3767
#    VDB-3768

print <<"END";
echo "building ngs-sdk library ..."
cd ngs
./configure >/dev/null 2>&1 || { echo "configure script failed"; exit 1; }
make -sj1 -C ngs-sdk >/dev/null 2>&1 || { echo "make failed"; exit 1; }
cd ..


END

do_repo 'sra-tools', qw{
    VDB-3739
    VDB-3786
};
