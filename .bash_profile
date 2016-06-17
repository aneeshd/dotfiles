#### Set architecture flags
###export ARCHFLAGS="-arch x86_64"
# Ensure user-installed binaries take precedence
export PATH=/usr/local/bin:$PATH
# Load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc

if ( hash brew 2>/dev/null ); then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		source $(brew --prefix)/etc/bash_completion
	fi
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
