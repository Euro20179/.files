" Author: euro
" Last Modified 12/19/2025 07:39
" Description: If the file contains the text `Last Modified: <date> <time>` it
" will replace that date and time with the current time on :w
function s:handleLastModified()
    let pos = getpos(".")
    try
        undojoin
        "no :undojoin after `u`
    catch /E790:/
        return
    endtry

    let count = search('\<Last Modified:\?\_$\?\n\?\_^\?\s*[[:digit:]]\{2\}\/[[:digit:]]\{2\}\/[[:digit:]]\{4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}\>', "p")
    if count == 0 | return | endif

    s/Last Modified:\?\_$\?\n\?\_^\?\s*\zs\([[:digit:]]\{2\}\/\)\{2\}[[:digit:]]\{2,4\} [[:digit:]]\{2\}:[[:digit:]]\{2\}/\=strftime("%m\/%d\/%Y %H:%M")

    call setpos(".", pos)
endfun

augroup lastmodifed
    au!
    exec 'au BufWriteCmd ' .. expand("$CLOUD") .. '/* call s:handleLastModified()'
    au BufWritePre * call s:handleLastModified()
augroup END

command! ILastMod norm iLast Modified =strftime("%m/%d/%Y %H:%M")
