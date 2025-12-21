" Author: euro
" Last Modified 12/20/2025 08:07
" Description: If the file contains the text `Last Modified: <date> <time>` it
" will replace that date and time with the current time on :w
function s:handleLastModified()
    let pos = getpos(".")
    let count = search('\<Last Modified:\?\_$\?\n\?\_^\?\s*[[:digit:]]\{2\}\/[[:digit:]]\{2\}\/[[:digit:]]\{4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}\>', "p")

    if count == 0
        call setpos(".", pos)
        return
    endif

    undojoin

    s/Last Modified:\?\_$\?\n\?\_^\?\s*\zs\([[:digit:]]\{2\}\/\)\{2\}[[:digit:]]\{2,4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}/\=strftime("%m\/%d\/%Y %H:%M")

    call setpos(".", pos)
endfun

augroup lastmodifed
    au!
    exec 'au BufWriteCmd ' .. expand("$CLOUD") .. '/* call s:handleLastModified()'
    au BufWritePre * call s:handleLastModified()
augroup END

command! ILastMod norm iLast Modified =strftime("%m/%d/%Y %H:%M")
