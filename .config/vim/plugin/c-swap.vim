function! ComplementaryFile()
    let ext = expand("%:e")
    execute 'e ' . expand("%:r") . '.' . substitute(ext, 'c\|h', '\=submatch(0) == "c" ? "h" : "c"', "i")
endfun

command! -bar Cofile call ComplementaryFile()
