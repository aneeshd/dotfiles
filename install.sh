#!/bin/bash

[ -d ~/.oh-my-zsh ] || sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# relink target-file source-file
relink() {
  if [[ -h "$1" ]]; then
    echo "Relinking $1"
    # Symbolic link? Then recreate.
    rm "$1"
    ln -sn "$2" "$1"
  elif [[ ! -e "$1" ]]; then
    echo "Linking $1 to $2"
    ln -sn "$2" "$1"
  else
    echo "$1 exists as a real file, skipping."
  fi
}

DIR=$( cd "$( dirname "$0" )" && pwd )

#relink ~/.bash_profile $DIR/.bash_profile
#relink ~/.bashrc $DIR/.bashrc
#relink ~/.bash_aliases $DIR/.bash_aliases
relink ~/.gitconfig $DIR/.gitconfig
relink ~/.gitignore_global $DIR/.gitignore_global
#relink ~/.screenrc $DIR/.screenrc
#relink ~/.inputrc $DIR/.inputrc
#relink ~/.tmux.conf $DIR/.tmux.conf
#relink ~/.vimrc $DIR/.vimrc
relink ~/.zshrc $DIR/.zshrc
relink ~/.profile $DIR/.profile
relink ~/.zprofile $DIR/.zprofile

mkdir -p ~/.hammerspoon
relink ~/.hammerspoon/init.lua $DIR/hammerspoon/init.lua

