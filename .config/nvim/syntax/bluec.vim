syn match bluecEnd ';end'

syn match bluecPrefix '^\['
syn match bluecCommand '^\[[[:alpha:]\-[:digit:]]\+'
syn match bluecIfCommand '\(\[if [^;]\+;\|\[else; if [^;]\+;\)\@<=.*\(;end\)\@='
syn match bluecVarDef '\(\[var[[:space:]]\+\)\@<=[^=]\+'

syn match bluecIf '^\[if [^;]\+;'
syn match bluecElse '^\[else[[:space:]]*;'
syn match bluecEscape '\\\(n\|\\\|s\|t\|u\|U\|b\|i\|S\|d\|D\)\({[^}]*}\)*'
syn match bluecVariable '\\[Vv]{[^}]\+}'
syn match bluecDoFirstReplace '%{\(-\?[[:digit:]]\)\?}'

syn match bluecEOL ';EOL$'

syn match bluecCreateAlias '\(\[alias[[:space:]]\+\)\@<=[^ ]\+'
syn match bluecCreateAliasCommand '\(\[alias[[:space:]]\+[^ ]\+[[:space:]]\+\)\@<=[^ ]\+'

syn region bluecIfCondition start='^\(\[if\|\[else; if\)' end=';'
syn region bluecDoFirst start='\(\\\)\@<!$(' end=')'
syn region bluecCalcFirst start='\(\\\)\@<!$\[' end='\]'
syn region bluecSubstitution start='{' end='}'


let b:current_syntax = "bluec"

hi def link bluecEOL Keyword
hi def link bluecEscape Constant
hi def link bluecPrefix Identifier
hi def link bluecCommand Identifier
hi def link bluecIfCommand Identifier
hi def link bluecVariable Identifier
hi def link bluecCreateAliasCommand Identifier
hi def link bluecCreateAlias Macro
hi def link bluecVarDef Define
hi def link bluecIfCondition Conditional
hi def link bluecElse Conditional
hi def link bluecEnd Keyword
hi def link bluecDoFirst Special
hi def link bluecCalcFirst Special
hi def link bluecDoFirstReplace Special
hi def link bluecSubstitution Special
