fun! OpenNextFile()
    let tmp = &autochdir
    set autochdir
    noau norm! 0
    call search(b:link_search)
    try
        norm! gf
    catch /E447/
        e <cfile>
    endtry
    let &autochdir = tmp
endfun

nnoremap <leader>g <CMD>call OpenNextFile()<CR>
