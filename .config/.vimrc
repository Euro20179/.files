"The point of this file is to be usable in vim and neovim

"OPTIONS{{{
let g:mapleader = " "

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
nnoremap <leader>S <CMD>split \| wincmd j<CR>
nnoremap <leader>V <CMD>vsplit \| wincmd l<CR>
nnoremap <leader>l        <CMD>tabnext<cr>
nnoremap <leader>h        <CMD>tabprev<CR>
nnoremap <leader><c-l>    <CMD>bn<CR>'
nnoremap <leader><c-h>    <CMD>bp<CR>
nnoremap <leader>t        <CMD>tabnew<CR>
nnoremap <leader>q        <CMD>tabclose<cr>
nnoremap <right>          <c-w>>
nnoremap <left>           <c-w><
nnoremap <up>             <c-w>+
nnoremap <down>           <c-w>-

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
nnoremap <c-l>           <CMD>C-w>l
nnoremap <c-j>           <CMD>C-w>j
nnoremap <c-h>           <CMD>C-w>h
nnoremap <c-k>           <CMD>C-w>k
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
