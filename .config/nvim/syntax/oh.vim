syn region ohString start='"' end='"'
syn region ohReference start='\[' end=']'

syn match ohParent '[^{}[:space:]]\+[[:space:]]*\({\)\@='

syn match ohDatalessParent '\(["[:digit:]]\)\@<![^{}[:space:]"\.]\+[[:space:]]*\(;\)\@='

syn match ohDelimiter '\((\|)\|{\|}\)'

syn match ohNumber '\d\+\(\.\d\+\)\?\([[:alpha:]]\+\)\?\(;\| \)\@='

let b:current_syntax = "oh"

hi def link ohReference Identifier
hi def link ohParent Identifier
hi def link ohDatalessParent Identifier
hi def link ohDelimiter Delimiter
hi def link ohNumber Number
hi def link ohString String
