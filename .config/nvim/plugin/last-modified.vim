function s:handleLastModified()
    let pos = getpos(".")

    let count = search('\<Last Modified\_$\?\n\?\_^\?\s*[[:digit:]]\{2\}\/[[:digit:]]\{2\}\/[[:digit:]]\{4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}\>', "p")
    if count == 0 | return | endif

    s/Last Modified\_$\?\n\?\_^\?\s*\zs\([[:digit:]]\{2\}\/\)\{2\}[[:digit:]]\{2,4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}/\=strftime("%m\/%d\/%Y %H:%M")

    call setpos(".", pos)
endfun

augroup lastmodifed
    au!
    exec 'au BufWriteCmd ' .. expand("$CLOUD") .. '/* call s:handleLastModified()'
    au BufWritePre * call s:handleLastModified()
augroup END

command! ILastMod norm iLast Modified =strftime("%m/%d/%Y %H:%M")
