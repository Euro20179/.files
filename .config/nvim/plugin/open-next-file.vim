fun! OpenNextFile()
    noau norm! 0
    call search(b:link_search)
    try
        norm! gf
    catch /E447/
        e <cfile>
    endtry

    "local cd into that directory to help me keep relative paths consistent
    "between files
    lcd %:p:h
endfun

nnoremap <leader>g <CMD>call OpenNextFile()<CR>
