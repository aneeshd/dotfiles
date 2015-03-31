export PATH=/usr/local/sbin:/usr/local/bin:$PATH
alias ls='ls -F'

# http://www.ukuug.org/events/linux2003/papers/bash_tips/
shopt -s histappend
PROMPT_COMMAND='history -a'
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# No ._ files in archives please
export COPYFILE_DISABLE=true

shopt -s cdspell

CDPATH='.:..:../..:~:~/Projects:~/Documents'

bind space:magic-space   # Space dynamically expands any ! history expansions

# Open a manpage in Preview, which can be saved to PDF
function pman {
   man -t "${1}" | open -f -a /Applications/Preview.app
}

