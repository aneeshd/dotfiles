#!/bin/sh

PACKAGES="\
	git \
	bash-completion \
	reattach-to-user-namespace \
	caskroom/cask/brew-cask \
	wget \
	scons \
"

if ( ! which brew ); then
	echo Installing Homebrew
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; 
fi

brew install $PACKAGES

