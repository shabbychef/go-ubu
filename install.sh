#! /bin/bash
#
# ubuntu install script; 
# run this on a fresh install;
#
# to run it, set the following variables:
#  SETUP_REPOS
#  INSTALL_BASIC
#  INSTALL_PYTHON
#  INSTALL_R
#  INSTALL_KDE
#  INSTALL_JULIA
#
# then
#
# sudo bash $0
#
# remotely, you can do 
#
# wget -q -O - http://remote.com/whatever | sudo bash
#

# todo: add docker?

export MYUBUNTU=`lsb_release -cs`

# some options#FOLDUP
SETUP_REPOS=${SETUP_REPOS:-true}
INSTALL_BASIC=${INSTALL_BASIC:-true}

INSTALL_PYTHON=${INSTALL_PYTHON:-true}
INSTALL_R=${INSTALL_R:-true}
INSTALL_KDE=${INSTALL_KDE:-false}
INSTALL_JULIA=${INSTALL_JULIA:-false}
#UNFOLD

# add some more repositories:#FOLDUP
if $SETUP_REPOS ; then
	if ! [ -x "add-apt-repository" ]; then
		sudo apt-get install -y software-properties-common
	fi
	#sudo add-apt-repository -y ppa:freenx-team
	#sudo add-apt-repository -y ppa:jtaylor/ipython-dev
	#sudo add-apt-repository -y ppa:pythonxy/pythonxy-devel
	#sudo add-apt-repository -y ppa:google/musicmanager 
	sudo add-apt-repository -y ppa:texlive-backports/ppa
	sudo add-apt-repository -y ppa:arnaud-hartmann/glances-stable

	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

	# for R:
	if $INSTALL_R ; then
		sudo cp /etc/apt/sources.list /tmp/
		echo '# need this to get latest and greatest R' | sudo tee -a /etc/apt/sources.list
		echo "deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu $MYUBUNTU/" | sudo tee -a /etc/apt/sources.list
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
		sudo add-apt-repository -y ppa:marutter/c2d4u
	fi
	if $INSTALL_JULIA ; then
		sudo add-apt-repository -y ppa:staticfloat/julianightlies
		sudo add-apt-repository -y ppa:staticfloat/julia-deps
	fi
fi
#UNFOLD

# refresh#FOLDUP
if $SETUP_REPOS || $INSTALL_BASIC || $INSTALL_PYTHON || $INSTALL_R || $INSTALL_KDE ; then
	sudo apt-get update
fi
#UNFOLD

# packages#FOLDUP
if $INSTALL_BASIC ; then
	# admin/linux
	sudo apt-get install -y aptitude apt-file wget
	sudo apt-file update &
	sudo apt-get install -y adduser bash-completion cron expect fdupes xclip
	sudo apt-get install -y build-essential cpp g++ gcc m4 make athena-jot dos2unix
	sudo apt-get install -y vim vim-conque vim-gtk vim-scripts exuberant-ctags
	sudo apt-get install -y git tig subversion mercurial
	sudo apt-get install -y openssh-client openssh-server ntp curl lynx
	sudo apt-get install -y screen tmux
	sudo apt-get install -y nmap resolvconf
	sudo apt-get install -y nfs-common smbclient fuse fuse-utils hdparm cryptsetup ccrypt cifs-utils samba 
	sudo apt-get install -y unzip bzip2 gzip zip p7zip-full
	sudo apt-get install -y lsof htop iotop glances
	sudo apt-get install -y rsnapshot
	sudo apt-get install -y tilda yakuake
	sudo apt-get install -y gkrellm gkrellmd 
	# x and such
	#sudo apt-get install -y xorg xserver-xorg xserver-xorg-core xserver-xorg-input-all xserver-xorg-input-evdev xserver-xorg-input-mouse  
	# freenx
	#sudo apt-get install -y freenx freenx-server
	#sudo apt-get install -y nxagent nxclient nxnode nxserver 
	# mail;  suddenly a total pain in the ass.
	sudo apt-get install -y mailx mailutils sendemail esmtp
	# see https://help.ubuntu.com/12.04/installation-guide/powerpc/mail-setup.html
	#sudo apt-get install -y exim4
	#sudo dpkg-reconfigure exim4-config
	# instead, try postfix?
	sudo apt-get install -y postfix
	# etc
	sudo apt-get install -y abiword gnumeric gnuplot hdf5-tools html2text 
	#sudo apt-get install -y gimp digikam imagemagick inkscape graphviz geeqie
	sudo apt-get install -y evince okular okular-extra-backends geeqie pdfjam
	sudo apt-get install -y antiword
	# ksnapshot much better
	#sudo apt-get install -y shutter
	#sudo apt-get install -y istanbul recordmydesktop
	sudo apt-get install -y chromium-browser firefox flashplugin-installer 
	#sudo apt-get install -y exaile ubuntu-restricted-addons
	#sudo apt-get install -y mplayer vlc mencoder eject ripperx
	#sudo apt-get install -y gringotts
	# see http://askubuntu.com/a/25614/41248
	sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
	sudo apt-get install -y -q ttf-mscorefonts-installer
	# fucking java
	sudo apt-get install -y openjdk-7-jre
	sudo apt-get install -y texlive texinfo qpdf lacheck chktex texlive-latex-extra texlive-full 
	#sudo apt-get install -y texlive-generic-extra tex
fi

if $INSTALL_KDE ; then
	sudo apt-get install -y kde-plasma-desktop
	sudo apt-get install -y ksnapshot kalarm kompare
	sudo apt-get install -y polkit-kde-1 
	# aptitude on kde? hmmm.
	#sudo apt-get install -y muon
fi
#UNFOLD

# python #FOLDUP
if $INSTALL_PYTHON ; then
	# needed for nbconvert?
	sudo apt-get install -y pandoc

	# ipython whatnot:
	#sudo add-apt-repository ppa:jtaylor/ipython-dev
	#sudo apt-get update
	sudo apt-get install -y ipython python-dev
	sudo apt-get upgrade ipython
	sudo apt-get install -y ipython-notebook
	# check your install now:
	ipython -V
	# should say 0.14-dev or 1.0-dev or whatever

	# to get pip:
	sudo apt-get install -y python-pip
	# now let pip upgrade itself!
	sudo pip install -y --upgrade pip 
	sudo pip install -y --upgrade virtualenv
	# now get the packages needed
	# R
	if $INSTALL_R; then
		sudo apt-get install -y r-base-core 
		sudo pip install rpy2
	fi
	sudo apt-get install -y libhdf5-serial-dev
	sudo pip install h5py
	sudo pip install oct2py
	# ugggh; needed for h5py? 
	#sudo apt-get install -y python-numexpr
	# fuck this;
	wget -O /tmp/numexpr.tgz 'http://numexpr.googlecode.com/files/numexpr-2.2.2.tar.gz'
	mkdir -p /tmp/numexpr
	tar -C /tmp/numexpr -zxvf /tmp/numexpr.tgz 
	cd /tmp/numexpr/numexpr-2.2.2 && python setup.py build && cd -
	cd /tmp/numexpr/numexpr-2.2.2 && sudo python setup.py install && cd -

	# needed for pytables:
	sudo apt-get install -y cython
	sudo pip install git+https://github.com/PyTables/PyTables.git@v.3.0.0#egg=tables

	# python something or other;
	sudo apt-get install -y python-mpmath

	# other necessaries:
	sudo pip install --upgrade pytz

	# to get bleeding edge sympy; bleah
	mkdir -p ~/src
	cd ~/src && git clone git://github.com/sympy/sympy.git
	cd ~/src/sympy && sudo python setupegg.py develop
	# ah, screw it, just get the ubuntu one.
	#sudo apt-get install -y python-sympy
fi
#UNFOLD

# R#FOLDUP
if $INSTALL_R ; then
	# to get curl-config for Rcurl for devtools:
	sudo apt-get install -y libcurl4-gnutls-dev
	# need this for inconsolata.sty. I kid you not
	sudo apt-get install -y texlive-fonts-extra
	sudo apt-get install -y r-base-core littler
	# devtools needs git2r which needs libssl
	sudo apt-get install -y libssl-dev libxml2-dev

	R --version

	echo "see also: http://cran.rstudio.com/bin/linux/ubuntu/README.html"

	# needed for Rmpfr:
	sudo apt-get install -y libmpfr-dev

	# ack
	sudo apt-get build-dep -y r-cran-rgl 


	sudo mkdir -p /etc/R
	cat <<RPROFILE_END | sudo tee -a /etc/R/Rprofile.site | sudo tee -a /root/.Rprofile

# CRAN mirror hack
local({
  # set a CRAN mirror
  r <- getOption("repos")
  r["CRAN"] <- "http://cran.r-project.org"
  options(repos = r)

	if (require(drat)) {
		drat::addRepo("eddelbuettel")
		drat::addRepo("shabbychef")
	}
})
RPROFILE_END

	# needed for install2.r
	# this does not work on a bare install...
	#sudo r -e 'install.packages(c("docopt"))'
	sudo R -e 'install.packages(c("docopt"))'

rinstall() {
	sudo r /usr/share/doc/littler/examples/install2.r -r http://CRAN.rstudio.com/ $@
}

	# get devtools, drat
	rinstall devtools drat

	# update devtools
	sudo r -l 'devtools' -e 'devtools::install_github("hadley/devtools")'


	# update drat
	# this also borked, apparently.
	#sudo r -l 'drat' -e 'drat::addRepo("eddelbuettel");update.packages(ask=FALSE)'
	sudo R --slave -e 'library(drat);drat::addRepo("eddelbuettel");update.packages(ask=FALSE)'

	# needed for ggplot2 deps?
	#sudo apt-get install -y r-cran-colorspace
	rinstall zoo digest lattice MASS \
		xts timeSeries \
		bitops RCurl \
		roxygen2 knitr \
		quantmod TTR \
		txtplot \
		ks sandwich \
		matrixcalc RMTstat \
		fBasics fOptions \
		testthat \
		Quandl \
		gtools \
		survey \
		functional \
		cluster Hmisc \
		shiny 

	sudo r -l 'devtools' -e 'devtools::install_github("rstudio/DT")'

	# ugh java to get xlsx
	sudo apt-get install -y openjdk-7-jdk
	sudo R CMD javareconf
	rinstall rJava xlsx

	rinstall Rcpp \
		ecp nnet car \
		h5r \
		googleVis \
		quadprog tseries \
		fracdiff forecast \
		R.matlab \
		survival clinfun saws rankhazard maxstat coxrobust \
		colorspace plyr ggplot2 \
		ggHorizon \
		reshape2 MCMCpack VGAM stringdist

	# <hot shit gesture>
	rinstall SharpeR MarkowitzR sadists

	sudo R --slave -e 'update.packages(ask=FALSE)'

	# whee. colored output.
	# see http://www.lepem.ufc.br/jaa/colorout.html
	# see also http://musicallyut.blogspot.com/2012/07/colors-in-r-console.html
	#wget -P /tmp http://www.lepem.ufc.br/jaa/colorout_1.0-2.tar.gz
	#sudo R CMD INSTALL /tmp/colorout*.tar.gz
	#rm /tmp/colorout*.tar.gz
	# this is in my drat now, so no worries:
	#rinstall colorout
	sudo R --slave -e 'download.file("http://www.lepem.ufc.br/jaa/vimr/colorout_1.1-1.tar.gz", destfile = "colorout_1.1-1.tar.gz"); \ 
								install.packages("colorout_1.1-1.tar.gz", type = "source", repos = NULL)'

	# get rstudio?
	echo "go to http://www.rstudio.com/ide/download/desktop"
	echo "get latest source, then"
	echo "sudo apt-get install -y libjpeg62"
	echo "sudo dpkg -i file.deb"

fi
#UNFOLD

# JULIA#FOLDUP
if $INSTALL_JULIA ; then
	sudo apt-get install -y julia
fi
#UNFOLD

# cron#FOLDUP
cat <<EOF | sudo tee /etc/cron.daily/packlist
#!/bin/sh

# put this in /etc/cron.daily to get a daily 'backup' of 
# an ubuntu install..

# Copy the installed package list to /etc/packlist.txt

dpkg --get-selections | perl -ane 'print $F[0],qq[\n];' > /etc/packlist.txt

# see http://askubuntu.com/a/99151/41248
BASED=`mktemp -d`

dpkg --get-selections > ${BASED}/Package.list
sudo cp /etc/apt/sources.list ${BASED}/sources.list
sudo apt-key exportall > ${BASED}/Repo.keys

tar -P -czf /etc/packup.tgz ${BASED}
rm -rf ${BASED}
EOF
#UNFOLD

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=sh:ft=sh:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
