enew! | e clipboard set
setl buftype=acwrite

function! s:onclose()
    let @+ = join(getline("1", "$"), "\n")
    q!
endfun

autocmd BufWriteCmd <buffer> call s:onclose()