#!/bin/zsh
USE_POWERLINE="true"

export SAVEHIST=1000
export HISTFILE=~/.local/share/zsh_history

setopt inc_append_history share_history

bindkey -v

unsetopt BEEP

#allow better tab completion
autoload -U compinit
compinit
_comp_options+=(globdots)
compdef _gnu_generic ytfzf
compdef _gnu_generic trash

setopt AUTO_CD
setopt CORRECT
setopt EQUALS
setopt DOTGLOB

#if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
#    source /usr/share/zsh/manjaro-zsh-prompt ]]
#fi

INSBEAM="3"
NORMBEAM="1"

#make cursor beam/block in ins/norm mode
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = "block" ]]; then
	#norm cursor
	echo -ne '\e['"$NORMBEAM"' q' 
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} == '' ]] || [[ $1 = "beam" ]]; then
	#ins cursor
	echo -ne '\e['"$INSBEAM"' q'
    fi
}
zle -N zle-keymap-select
#initial cursor
zle-line-init(){
    zle -K viins
    #beam
    echo -ne "\e['"$INSBEAM"' q"
}
zle -N zle-line-init
#initial cursor
echo -ne '\e['"$INSBEAM"' q'
preexec() { echo -ne '\e['"$INSBEAM"' q'; }
#END CURSOR

rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" --show-only-dirs
    if [ -f "$tmp" ]; then
	dir="$(cat "$tmp")"
	rm -f "$tmp"
	[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

#all of this is the prompt{{{
setopt prompt_subst
autoload -U colors && colors
formatPath () {
    printf "%s/" "${1/$HOME/~}"
}

precmd () {
    print -Pn "\e]133;A\e\\"
    #get first, 2nd to last, and last folder in $PWD
    pwd=$(formatPath "$PWD")
    [ -d ".git" ] && {
	read branch < ".git/HEAD"
	curr_branch="{${branch##*/}}"
    } || curr_branch=
    fileCount="$(ls -A | wc -l)"
}

PS1='(%F{%(?.green.red)}%?%F{reset})[%F{039}$pwd%F{reset} %F{yellow}($fileCount%)%F{reset}]%F{magenta}$curr_branch% %F{reset}$ '

enable_plugin () {
    if [[ -e ~/.config/zshplugs/$1/$1.plugin.zsh ]]; then
	source ~/.config/zshplugs/$1/$1.plugin.zsh
    fi
}
#}}}

preexec () {
    printf '\033]0;%s (foot)\a' "$1"
}

enable_plugin "zsh-syntax-highlighting"
enable_plugin "zsh-auto-complete"
enable_plugin "fzf-tab"
#enable_plugin "zsh-autocomplete"

alias "ref=clear; source ~/.config/.zshrc"    

__calc () {
    zcalc -f -e "$*"
}

aliases[=]='noglob __calc'

source ~/.config/.shellrc
