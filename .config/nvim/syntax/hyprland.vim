syn match hyprVariable '^\$[^=]*'
syn match hyprKeyword '^\([[:space:]]*\)\@<=[^=$]*\(=\)\@='
syn match hyprComment '#.*'
syn match hyprSection '[^{]*\({\(\n[^}]*\)*}\)\@='

hi def link hyprSection @namespace
hi def link hyprComment Comment
hi def link hyprVariable Identifier
hi def link hyprKeyword Function
