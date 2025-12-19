" Last Modified: 12/19/2025 07:38
" Description: binds the keymap <leader>g that jumps to the next instance of
"              b:link_search (which should be set in an ftplugin) then
"              attempts to open <cfile> if <cfile> doesn't exist, create it as
"              a new buffer.
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
