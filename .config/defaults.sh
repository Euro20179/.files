#!/bin/sh
export BROWSER_LITE="_BROWSER_LITE"
export BROWSER="_BROWSER"
export BROWSER_SCRIPTING="linkhandler"
export MANPAGER="nvim +Man!"

export GEMINI=kristall

export PAGER=pager
export TERMINAL_HOLD_OPT='-H'
export TERMINAL="foot"
export MENU_LAUNCHER="os-menu"
export MENU="menu"
export IMAGE_VIEWER="display"
export GUIEDITOR=neovide
export EDITOR="nvim"
export OPENER="xdg-open"
export EMAIL="thunderbird -mail"
export CALENDAR="m=\$(date +%B); $GUIEDITOR $WIKI/CAL.mmfml -- +exec' \"norm gO\" | wincmd k' +Lfilter'! /Calendar/' +Lfilter/\"\$m/\" +\"/= \$m\""
export VIDEO_PLAYER="mpv --geometry=1000"
export AUDIO_PLAYER="mpv --no-video"
export MATRIX="nheko"
export FILEMANAGER="ranger"
export SYSMON="btop"
export UNICODE_PICKER="pick-emoji"
export LOCKER="lock"
#export LOCKER="gtklock -t 'Funbook Air'"
export TRASH="$HOME/.local/share/trash"
