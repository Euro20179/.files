"The point of this file is to be usable in vim and neovim

"OPTIONS{{{
let g:mapleader = " "

set list listchars=extends:❯,precedes:❮

set nocp

set lazyredraw

set scrolloff=3

set splitbelow splitright

set dictionary=/usr/share/dict/american-english spelllang=en_us

set nu rnu

set autoindent shiftwidth=4 tabstop=4 expandtab

set noswapfile

set foldmethod=marker

set ignorecase smartcase

set tildeop

set termguicolors

set display+=uhex

set formatoptions=jql

set cursorline

set fillchars=eob:󰅖

"fixes weird bug with Telescope help_menu tags not being sorted and lazy complaining
set tagcase=ignore

set smoothscroll

set conceallevel=2

set exrc

set nowrap

set colorcolumn=100

"}}}

"LL and QF stuff{{{
funct <SID>toggleQFWinType(opener, closer)
    if &filetype == "qf"
        call execute(a:closer)
    else
        call execute(a:opener)
    endif
endfu

nnoremap <c-q> <CMD>call <SID>toggleQFWinType("cwin", "cclose")<CR>
nnoremap <c-s-q> <CMD>call <SID>toggleQFWinType("lwin", "lclose")<CR>

nnoremap <leader>/ :silent lgrep! \| lwindow<S-Left><S-Left>

nnoremap <c-c><c-n> <CMD>cnext<CR>
nnoremap <c-c><c-p> <CMD>cprev<CR>
"}}}
"Copy shortcuts{{{
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>d "_d
nnoremap <leader>c "_c
nnoremap <leader>b "_
nnoremap <leader>B "+
"}}}
"Buffer/window shortcuts{{{
nnoremap  <leader>S      <CMD>split \|  wincmd  j<CR>
nnoremap  <leader>V      <CMD>vsplit \|  wincmd  l<CR>
nnoremap  ]t             <CMD>tabnext<CR>               
nnoremap  [t             <CMD>tabprev<CR>               
nnoremap  ]b             <CMD>bn<CR>'                   
nnoremap  [b             <CMD>bp<CR>                    
nnoremap  ]q             <CMD>cnext<CR>
nnoremap  [q             <CMD>cprev<CR>
nnoremap  ]l             <CMD>lnext<CR>
nnoremap  [l             <CMD>lprev<CR>
nnoremap  <leader>t      <CMD>tabnew<CR>                
nnoremap  <leader>q      <CMD>tabclose<cr>              
nnoremap  <right>        <c-w>>                         
nnoremap  <left>         <c-w><                         
nnoremap  <up>           <c-w>+                         
nnoremap  <down>         <c-w>-                         


funct <SID>navigateToVimWiki()
    call chdir(expand("~/Documents/vimwiki"))
    edit index.norg
endfu

nnoremap <leader>vw <CMD>call <SID>navigateToVimWiki()<CR>
"}}}
"Syntax highlighting {{{
nnoremap <c-n> <CMD>noh<CR>
nnoremap <C-s>           <CMD>setlocal spell! spelllang=en_us<CR>
nnoremap <A-s>           <CMD>syntax sync fromstart<CR>
"}}}
"Normal movement {{{
nnoremap <c-l>           <C-w>l
nnoremap <c-j>           <C-w>j
nnoremap <c-h>           <C-w>h
nnoremap <c-k>           <C-w>k
"}}}
"copying in visual mode {{{
vnoremap <leader>y       "+y
vnoremap <leader>d       "_d
vnoremap <leader>c       "_c
vnoremap <leader>p       "+p
"}}}
"indents {{{
vnoremap < <gv
vnoremap > >gv
"}}}
"Better pipe mnemonic{{{
vnoremap \| !
nnoremap \| !
"}}}
"paste from term {{{
inoremap <c-s-v> <c-r>+
nnoremap <c-s-v> a<c-r>+<esc>
"}}}

"Im tired of pressing ctrl-w and closing tabs
inoremap <c-w> <nop>

"When entering cmdline toggle relativenumber
augroup relnutoggle
    au!
    autocmd CmdlineEnter * set nornu | redraw
    autocmd CmdlineLeave * set rnu | redraw
augroup END

"{ 0xf0001, 0xf1af0, 2 }, conflicts with 'fillchars'
call setcellwidths([
    \ [ 0xe5fa, 0xe6ac, 2 ],
    \ [ 0xea60, 0xebeb, 2 ],
    \ [ 0xe000, 0xe00a, 2 ],
    \ [ 0xf300, 0xf32f, 2 ],
    \ [ 0x23fb, 0x23fe, 2 ],
    \ [ 0x2b58, 0x2b58, 2 ],
    \ [ 0xe0a3, 0xe0a3, 2 ],
    \ [ 0xe0b4, 0xe0c8, 2 ],
    \ [ 0xe0ca, 0xe0ca, 2 ],
    \ [ 0xe0cc, 0xe0d4, 2 ],
    \ [ 0xe0a0, 0xe0a2, 2 ],
    \ [ 0xe0b0, 0xe0b3, 2 ],
    \ [ 0xf400, 0xf532, 2 ],
    \ [ 0x2665, 0x26A1, 2 ],
    \ [ 0xe300, 0xe3e3, 2 ],
    \ [ 0xe200, 0xe2a9, 2 ],
    \ [ 0xf000, 0xf2e0, 2 ],
    \ [ 0xe700, 0xe7c5, 2 ]
\ ])

if has("nvim")
    let s:vimpath = expand("$XDG_CONFIG_HOME/nvim/init.vim")
    if filereadable(s:vimpath)
        exec "so " . s:vimpath
    else
        let s:luapath = expand("$XDG_CONFIG_HOME/nvim/init.lua")
        if filereadable(s:luapath)
            exec "so " . s:luapath
        end
    endif
endif
