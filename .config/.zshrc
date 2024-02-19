#!/bin/zsh
USE_POWERLINE="true"

#makes it not error on no glob match
set -3

export SAVEHIST=1000000
export HISTSIZE=1000000
export HISTFILE=~/.local/share/zsh_history

setopt inc_append_history share_history

unsetopt BEEP

bindkey -v
bindkey '^b' backward-char
bindkey '^f' forward-char
bindkey '^a' beginning-of-line
bindkey '^g' end-of-line
bindkey '^e' forward-word
bindkey '^p' backward-word
bindkey '^[[27;2;13~' accept-line

#allow better tab completion
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
[ -z "$IN_VIM" ] && zle -N zle-keymap-select
# #initial cursor
zle-line-init(){
zle -K viins
#beam
echo -ne "\e['"$INSBEAM"' q"
}
[ -z "$IN_VIM" ] && zle -N zle-line-init
# #initial cursor
[ -z "$IN_VIM" ] && echo -ne '\e['"$INSBEAM"' q'
[ -z "$IN_VIM" ] && preexec() { echo -ne '\e['"$INSBEAM"' q'; }
#END CURSOR

chpwd () {
    [ "$OLDPWD" != "$PWD" ] && [ -d ".git" ] && onefetch
}

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
    [ "$1" = "$HOME" ] && printf "%s" "" || case "$1" in
    $CLOUD) printf "%s" "󰒋" ;;
    $CLOUD*) printf "%s" "${1/$CLOUD*/󰒋 }" "${1/*$CLOUD\//}" ;;
    $HOME*) printf "%s" "${1/$HOME*/ }" "${1/*$HOME\//}" ;;
    *) printf "$1" ;;
esac
}

precmd () {
    #shell integration osc133A tells where the prompt is
    print -Pn "\e]133;A\e\\"
    #get first, 2nd to last, and last folder in $PWD
    pwd=$(formatPath "$PWD")
    if [ -d ".git" ]; then
        read branch < ".git/HEAD"
        curr_branch="  ${branch##*/}"
    else curr_branch=
    fi
    #this shpiel is faster than fileCount=$(ls -A | wc -l)
    set -- *
    [ "$1" = "*" ] && fileCount=0 || fileCount="$#"
}

new_line=$'\n'

if [ -z "$IN_VIM" ]; then
    PS1='%F{%(?.green.red)}%(?..%?)%F{reset}%(?.. - )%F{yellow}[$fileCount]%F{reset} %F{039}$pwd%F{reset} %F{magenta}$curr_branch% %F{reset}%F{%(?.green.red)}$new_line%F{reset} '
else
    PS1='%F{%(?.green.red)}%(?..%?)%F{reset}%(?.. - )%F{yellow}[$fileCount]%F{reset} %F{039}$pwd%F{reset} %F{magenta}$curr_branch% %F{reset}%F{%(?.green.red)}$new_line>%F{reset} '
fi

enable_plugin (){
    [[ -e ~/.config/zshplugs/$1/$1.plugin.zsh ]] && source ~/.config/zshplugs/$1/$1.plugin.zsh
}

#}}}

preexec () printf '\033]0;%s - %s (foot)\a' "$PWD" "$1"


enable_plugin "zsh-syntax-highlighting"
enable_plugin "zsh-auto-complete"
# enable_plugin "fzf-tab-completion/zsh"
source "$HOME/.config/zshplugs/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
bindkey '^I' fzf_completion
zstyle ":completion:*" fzf-search-display true
# enable_plugin "zsh-autocomplete"

alias "ref=clear; source ~/.config/.zshrc"    

source ~/.config/.shellrc

if [ "$IN_VIM" ]; then
    unalias ls
    alias l='ls -A --color=always -S --group-directories-first'
fi

fpath=("$XDG_CONFIG_HOME"/zsh-autoload "${fpath[@]}")
autoload -U compinit
compinit
_comp_options+=(globdots)
compdef _gnu_generic ytfzf
compdef _gnu_generic trash
