export PATH=/usr/local/sbin:/usr/local/bin:$PATH

# http://www.ukuug.org/events/linux2003/papers/bash_tips/
shopt -s histappend
PROMPT_COMMAND='history -a'
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# No ._ files in archives please
export COPYFILE_DISABLE=true

shopt -s cdspell

#CDPATH='.:..:../..:~:~/Projects:~/Documents'

bind space:magic-space   # Space dynamically expands any ! history expansions

export PYTHONSTARTUP=$HOME/dotfiles/startup.py

# If the output is smaller than the screen height is smaller,
# less will just cat it
# + support ANSI colors
export LESS="-FX -R"

# Syntax coloring with pygments in less, when opening source files
export LESSOPEN='|~/dotfiles/lessfilter.sh %s'

# Open a manpage in Preview, which can be saved to PDF
function pman {
   man -t "${1}" | open -f -a /Applications/Preview.app
}

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

if [ -f ~/.bash_aliases.custom ]; then
  source ~/.bash_aliases.custom
fi

