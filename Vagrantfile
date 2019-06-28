# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-18.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get --quiet update

    # install build tools
    apt-get --quiet install -y gcc g++ gdb git make
    
    # install perl and dependencies
    apt-get --quiet install -y perl
    
    # make CPAN run without interaction
    PERL_MM_USE_DEFAULT=1 PERL_EXTUTILS_AUTOINSTALL="--defaultdeps" perl -MCPAN -e'install Bundle::CPAN'

    # install cpan- for even less interaction
    cpan App::cpanminus

    # install dependencies for driver tool perl script
    cpanm Cwd LWP::Protocol::https XML::LibXML


    rm -rf /usr/local/ncbi /etc/ncbi /etc/profile.d/sra-tools.[c]sh # remove old install if any
    rm -rf ngs ncbi-vdb sra-tools ncbi-outdir .ncbi

    # get fresh repo's
    git clone --branch engineering https://github.com/ncbi/ngs.git    
    git clone https://github.com/ncbi/ncbi-vdb.git
    git clone https://github.com/ncbi/sra-tools.git
    
    source /vagrant/integrate.sh
    
    echo "installing sra-tools to default location"
    cd sra-tools
    make install
    # copy driver tool (normally would be done by installer script)
    cp tools/driver-tool/sratools.pl /usr/local/ncbi/sra-tools/bin/
    cd ..

    # clean up build artifacts
    rm -rf ngs ncbi-vdb sra-tools ncbi-outdir


    # setup links (normally would be done by installer script)
    pushd /usr/local/ncbi/sra-tools/bin/

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
    
    popd
    # test the driver tool
    perl /usr/local/ncbi/sra-tools/bin/sratools.pl runtests    
    
    echo "After running the following command, you should be able to fastq-dump SRA000001:"
    echo "vdb-config --set /repository/remote/main/CGI/resolver-cgi=https://www.ncbi.nlm.nih.gov/Traces/sdl/1/retrieve"
    echo "NB. you can not run vdb-config as root"
  SHELL
end
