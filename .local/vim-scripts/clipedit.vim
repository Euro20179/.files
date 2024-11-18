enew! | e! clipboard edit
setlocal buftype=acwrite

function! <SID>onclose()
    let @+ = join(getline("1", "$"), "\n")
    q!
endfun

autocmd BufWriteCmd <buffer> call <SID>onclose()
