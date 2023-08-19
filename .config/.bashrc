#!/bin/bash

. .config/.shellrc

shopt -s autocd

set -o history
set -H

HISTFILESIZE=1000
HISTSIZE=1000


#PS1 {{{
format_exit_code () {
    color=$((($1<1)+1))
    echo -ne "\033[3${color}m$1\033[0m"
}

formatPath () {
    dir="${1/$HOME/\~}"
    IFS="/"
    dir=(${dir})
    dir=${dir:-/}
    [ "$#" -lt 5 ] &&  echo -n "${dir[*]}" || echo -n "$1/../${dir[-2]}/${dir[-1]}"
}

format_git(){
    [ -d ".git" ] && printf "{\033[35m%s\033[0m}" "$(git branch --show-current)"
}

PS1='($(format_exit_code "$?"))[\[\033[36m\]$(formatPath "$PWD")\[\033[0m\] (\[\033[33m\]$(ls -1A | wc -l)\[\033[0m\])]$(format_git) '
#incase PS1 breaks the line wrapping
#\n\[\033[32m\]$\[\033[0m\]
#}}}

export HISTFILE="~/.local/share/bash_history"

alias most-used="history | sed 's/^[[:space:]]*[[:digit:]]*  //' | sort | uniq -c | sort -n"

#STARTUP


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
