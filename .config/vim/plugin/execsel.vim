function! s:ExecSelection(line1, line2, inShell)
    let l:lines = getline(a:line1, a:line2)

    if a:inShell == "!"
        execute '!' . join(l:lines, ";")
        return
    endif

    if !exists(":terminal")
        echoerr ":terminal is not supported in this version, please use Exec!"
        finish
    endif

    tabnew
    execute 'terminal ' . join(l:lines, ";")
    silent! wincmd o
endfun

command -range -bang Exec call s:ExecSelection(<line1>, <line2>, "<bang>")
