# shabbycon
#
# VERSION 0.1
#
# shabbycon
#
# docker build -t dregistry:5000/shabbycon .
#
# SVN: $Id: Dockerfile 41706 2014-05-15 19:46:42Z steven $
# Created: 2014.05.23
# Copyright: Steven E. Pav, 2014
# Author: Steven E. Pav
# Comments: Steven E. Pav

#####################################################
# preamble# FOLDUP
FROM ubuntu:12.04

MAINTAINER Steven E. Pav, shabbychef@gmail.com

#ENV DOCKFILE_REFRESHED_AT 2014.03.21
# this is just hell: turn it off, or do not check in so much.
#ENV DOCKFILE_SVN_ID '$Id: Dockerfile 41706 2014-05-15 19:46:42Z steven $'

USER root
# UNFOLD

#####################################################
# update ubuntu# FOLDUP
# see http://crosbymichael.com/dockerfile-best-practices.html
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted" >> /etc/apt/sources.list.d/precise-updates.list
#RUN (apt-get update -qq && apt-get upgrade -y -qq && apt-get -y -qq autoclean && apt-get -y -qq autoremove)
RUN (apt-get update -qq && apt-get upgrade -y -qq)
RUN echo "root:vegetable" | chpasswd

RUN DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  apt-get install -y -qq python-software-properties lsb-release aptitude
# UNFOLD

#####################################################
# get package dependencies# FOLDUP
RUN (add-apt-repository -y ppa:jtaylor/ipython-dev ; \
	add-apt-repository -y ppa:pythonxy/pythonxy-devel ; \
	add-apt-repository -y ppa:staticfloat/julia-deps ; \
	add-apt-repository -y ppa:texlive-backports/ppa ; \
	add-apt-repository -y ppa:arnaud-hartmann/glances-stable )

RUN MYUBUNTU=$(lsb_release -cs) && /bin/echo "deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu $MYUBUNTU/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN (DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	apt-get update -qq && apt-get upgrade -y -qq)

RUN DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  aptitude install -y -q --no-gui -f -V \
  wget less perl sudo \
	apt-file \
	adduser bash-completion cron fdupes xclip \
	cpp g++ gcc m4 make athena-jot dos2unix \
	vim vim-conque vim-scripts exuberant-ctags \
	git tig subversion mercurial \
	openssh-client openssh-server ntp curl lynx \
	screen tmux \
	nmap cryptsetup \
	unzip bzip2 gzip zip p7zip-full \
	lsof htop iotop glances \
	texlive texinfo qpdf lacheck chktex texlive-latex-extra \
	texlive-full \
	gnuplot hdf5-tools html2text \
	imagemagick graphviz gqview \
	evince okular okular-extra-backends geeqie pdfjam \
	antiword \
	openjdk-7-jre openjdk-7-jdk \
	libcurl4-gnutls-dev \
	texlive-fonts-extra \
	r-base littler \
	libmpfr-dev 

RUN R --version


RUN mkdir -p /etc/R

ENV HOME /root
RUN mkdir -p $HOME

RUN /bin/echo -e '# CRAN mirror hack\n\
	local({\n\
		# set a CRAN mirror\n\
		r <- getOption("repos")\n\
		r["CRAN"] <- "http://cran.r-project.org"\n\
		options(repos = r)\n\
	})\n' | tee -a /etc/R/Rprofile.site > $HOME/.Rprofile

#RUN apt-get build-dep -y r-cran-rgl 

ENV USER root
ENV R_USER root
ENV R_PROFILE_USER /root/.Rprofile

RUN DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  aptitude install -y -q --no-gui -f -V \
  r-base r-base-dev littler \
  libcurl4-gnutls-dev \
  pandoc libpq-dev libmysqlclient-dev libx11-dev \
  libxml2-dev mesa-common-dev \
  libcairo2-dev libxt-dev

# rmarkdown needs pandoc?
# rgl   needs libx11-dev, mesa-common-dev
# XML   needs libxml2-dev
# RMySQL needs libmysqlclient-dev
# bigrquery needs libpq?
# Cairo needs libcairo2-dev libxt-dev

RUN R -e 'install.packages(c("devtools"),repos="http://cran.rstudio.com/")'
RUN R -e 'require(devtools); devtools::install_github("hadley/devtools")'

RUN (R --slave -e 'install.packages(c("zoo","digest","lattice","MASS"))' ;\
	R --slave -e 'install.packages(c("xts","timeSeries"))' ;\
	R --slave -e 'install.packages(c("bitops","RCurl"))' ;\
	R --slave -e 'install.packages(c("roxygen2","knitr"))' ;\
	R --slave -e 'install.packages(c("quantmod","TTR"))' ;\
	R --slave -e 'install.packages(c("txtplot"))' ;\
	R --slave -e 'install.packages(c("ks","sandwich"))' ;\
	R --slave -e 'install.packages(c("matrixcalc","RMTstat"))' ;\
	R --slave -e 'install.packages(c("fBasics","fOptions"))' ;\
	R --slave -e 'install.packages(c("testthat"))' ;\
	R --slave -e 'install.packages(c("Quandl"))' ;\
	R --slave -e 'install.packages(c("gtools"))' ;\
	R --slave -e 'install.packages(c("survey"))' ;\
	R --slave -e 'install.packages(c("functional"))' ;\
	R --slave -e 'install.packages(c("cluster","Hmisc"))' ;\
	R --slave -e 'install.packages(c("shiny"))' )

RUN R CMD javareconf

RUN (R --slave -e 'install.packages(c("reshape2"))' ;\
	R --slave -e 'install.packages(c("MCMCpack"))' ;\
	R --slave -e 'install.packages(c("VGAM"))' ;\
	R --slave -e 'install.packages(c("SharpeR","MarkowitzR"))')

RUN R --slave -e 'update.packages(ask=FALSE)'

#RUN wget -P /tmp http://www.lepem.ufc.br/jaa/colorout_1.0-2.tar.gz
RUN wget -P /tmp http://www.lepem.ufc.br/jaa/colorout_1.0-3.tar.gz
RUN R CMD INSTALL /tmp/colorout*.tar.gz

## see http://askubuntu.com/a/25614/41248
#sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
#sudo apt-get install -y -q ttf-mscorefonts-installer

# UNFOLD

#####################################################
# setup

WORKDIR /tmp
ADD install.sh /tmp/
#RUN bash /tmp/install.sh

#####################################################
# entry and cmd# FOLDUP

# note that a VOLUME is created at *run time*, not during the
# image build. thus you probably should put VOLUME commands
# after *all* RUN commands to avoid confusion: you cannot
# interact with VOLUMES with RUN commands.
VOLUME ["/tmp/name","/var/foo"]

# why not?
WORKDIR /tmp
USER root

# Expose ssh?
#EXPOSE 22 

# always use array syntax:
ENTRYPOINT ["/usr/sbin/cron"]

# ENTRYPOINT and CMD are better together:
CMD ["-f"]
# UNFOLD

#for vim modeline: (do not edit)
# vim:nu:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=Dockerfile:ft=Dockerfile:fo=croql
