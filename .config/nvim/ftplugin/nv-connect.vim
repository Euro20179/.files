let s:file = expand("%")

let s:addr = s:file[5:]
let s:port = 1111
let s:fullAddr = s:addr .. ":" .. s:port

exec 'connect ' . s:fullAddr
