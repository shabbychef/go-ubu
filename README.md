go-ubu
======

ubuntu build script; To run this, first test via

	wget -q -O - https://raw.github.com/shabbychef/go-ubu/master/test.sh | sudo bash
	ls -al /tmp/as*

There should be a file called `/tmp/as_sudo.txt`, owned by root. Now to
run, call:

	export INSTALL_R=true
	export INSTALL_PYTHON=false
	wget -q -O - https://raw.github.com/shabbychef/go-ubu/master/install.sh | sudo bash

