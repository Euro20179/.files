function! <SID>runtemplate()
    let templates_dir = stdpath("config") .. "/templates"
    let file = findfile(templates_dir .. "/" .. &ft .. ".vim")
    echo templates_dir .. "/" .. &ft .. ".vim" 
    if file != ""
        execute 'source ' . file
    endif
endfun
autocmd BufNewFile * call <SID>runtemplate()
