#!/bin/sh

PACKAGES="\
	git \
	bash-completion \
	reattach-to-user-namespace \
	brew-cask \
	wget \
	scons \
	tmux \
"

CASKS="\
	virtualbox \
	vagrant \
	vagrant-manager \
"

if ( ! which brew ); then
	echo Installing Homebrew
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; 
fi

brew update
brew upgrade

brew tap caskroom/cask
brew tap caskroom/versions

brew install $PACKAGES
#brew cask install $CASKS

brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package && qlmanage -r

brew cleanup
brew prune

