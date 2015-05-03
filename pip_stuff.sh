#!/bin/sh

if ( ! which pip ); then
	sudo easy_install pip
fi

sudo pip install --upgrade pygments
sudo pip install --upgrade pygments-style-solarized

