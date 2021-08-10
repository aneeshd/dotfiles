#!/bin/sh

PACKAGES="\
	coreutils \
	wget \
	dos2unix \
	ag \
"

CASKS="\
	iterm2 \
	hammerspoon \
	brave-browser \
	visual-studio-code \
"

if ( ! which brew ); then
	echo Installing Homebrew
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; 
fi

brew update
brew upgrade

brew install $PACKAGES
brew install $CASKS

brew install betterzip qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize apparency quicklookase qlvideo qlprettypatch quicklook-csv webpquicklook suspicious-package && qlmanage -r
xattr -d -r com.apple.quarantine ~/Library/QuickLook

brew cleanup

