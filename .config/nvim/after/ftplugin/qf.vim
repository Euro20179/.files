nnoremap <buffer> <silent> dd <cmd>mark ' <bar> call setqflist(filter(getqflist(), { idx -> idx != line(".") - 1 }), "r") <bar> norm ''<cr>
