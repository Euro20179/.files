enew! | e clipboard edit
setl buftype=acwrite

call setline(1, @+[:-1])

function! s:onclose()
    let @+ = join(getline("1", "$"), "\n")
    q!
endfun

autocmd BufWriteCmd <buffer> call s:onclose()
