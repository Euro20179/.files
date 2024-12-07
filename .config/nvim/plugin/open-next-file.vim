fun! OpenNextFile()
    noau norm! 0
    call search(b:link_search)
    try
        norm! gf
    catch /E447/
        e <cfile>
    endtry
endfun

nnoremap <leader>g <CMD>call OpenNextFile()<CR>
