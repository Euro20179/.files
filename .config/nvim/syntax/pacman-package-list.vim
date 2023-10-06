syn match packageName '^[^ ]\+'
syn match packageVersion ' [^ ]\+$'

hi def link packageName String
hi def link packageVersion Number
