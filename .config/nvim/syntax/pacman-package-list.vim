syn match packageName '^[^ ]\+'
syn match packageVersion ' [^ ]\+$'

hi def link packageName Function
hi def link packageVersion Number
