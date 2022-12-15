#!/bin/sh

#this is for styling ytfzf, I have it seperate for my sys-theme program

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color fg:#b3b3b3,fg+:#FFCB68,hl:#7D71B7,border:#7D71B7,query:#64CBF8,pointer:#FFCB68"

_get_var () {
    echo "get $1" > "$ipc_file"
    #just wait until the file exists
    until [ -f "$ipc_file.$1" ]; do :; done
    cat "$ipc_file.$1" 2> /dev/null
    rm "$ipc_file.$1"
}

print_statusline () {
    uh=$(_get_var url_handler)
    ao=$(_get_var is_audio_only)
    d=$(_get_var is_detach)
    pref=$(_get_var ytdl_pref)
    extension_count=0
    for e in $loaded_extensions; do
	extension_count=$((extension_count+1))
    done
    unset e
    printf "${c_bold}%s${c_reset} %s\n" "Active extensions:" "$extension_count" "url handler:" "$uh" "is audio only?" "$ao" "detach?" "$d" "ytdl pref:" "$pref"
    printf "%.$(tput cols)s\n" "----------------------------------------------------------------------------------------------------------------------------------------------"
}

thumbnail_video_info_text () {
	case "$loaded_extensions" in
	    *' 'ipc*) [ "$__is_submenu" -eq 0 ] && print_statusline ;;
	esac
	[ "$views" -eq "$views" ] 2>/dev/null && views="$(printf "%s" "$views" | add_commas)"
	[ -n "$title" ] && printf "\n ${c_cyan}%s" "$title"
	[ -n "$channel" ] && printf "\n ${c_blue}Channel  ${c_green}%s" "$channel"
	[ -n "$duration" ] && printf "\n ${c_blue}Duration ${c_yellow}%s" "$duration"
	[ -n "$views" ] && printf "\n ${c_blue}Views    ${c_magenta}%s" "$views"
	[ -n "$date" ] && printf "\n ${c_blue}Date     ${c_cyan}%s" "$date"
	[ -n "$scraper" ] && printf "\n ${c_blue}Scraper${c_clear}  %s" "$scraper"
	[ -n "$description" ] && printf "\n ${c_blue}Description ${c_reset}: %s" "$(printf "%s" "$description" | sed 's/\\n/\n/g')"
}
