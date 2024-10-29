#!/bin/nvim -S
"The point of this file is to be usable in vim and neovim

"vim compatible default colorscheme
color desert

"vim bad defaults
if !has("nvim")
    syntax enable
    set mouse=a
endif

"OPTIONS{{{
let g:mapleader = " "

set grepprg=rg\ --vimgrep\ $*

if finddir(".git", ".;", 1) == ".git"
    set grepprg=git\ grep\ -n\ $*
    set grepformat=%f:%l:%m
endif

set list listchars=tab:.\ 

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

"set formatoptions=jql

set cursorline

"fixes weird bug with Telescope help_menu tags not being sorted and lazy complaining
set tagcase=ignore

set smoothscroll

set conceallevel=2

set exrc

set nowrap

set colorcolumn=80


"Setup findexpr, make <leader>ff find files using the :find command
"Otherwise, later in shortcuts.lua, <leader>ff uses mini.builtins.findfiles
"(similar to telescope)
if exists("&findexpr")
    if finddir(".git") != ""
        func FindFiles()
            let fnames = systemlist("git ls-files")
            return fnames->filter("v:val =~? v:fname")
        endfun
    else
        func FindFiles()
            let cmd = v:cmdcomplete ? $'fd {v:fname}' : "fd"
            let fnames = systemlist(cmd)
            return fnames->filter("v:val =~? v:fname")
        endfun
    endif

    set findexpr=FindFiles()

    if function("nvim_set_keymap") != 0
        call nvim_set_keymap("n", "<leader>ff", ":find ", {"desc": "[TELESCOPE] Find files and open", "noremap": v:true})
    else
        nnoremap <leader>ff :find 
    endif
endif

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
nnoremap x         "_x
nnoremap X         "_X
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
nnoremap  <right>        <CMD>wincmd ><CR>
nnoremap  <left>         <CMD>wincmd <<CR>
nnoremap  <up>           <CMD>wincmd +<CR>
nnoremap  <down>         <CMD>wincmd -<CR>


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
inoremap <c-backspace> <c-w>

"This SHOULD be the default (insert + fix indent)
"no idea why it needs to be the literal bytes instead of <c-r><c-p>
exec "inoremap <c-r> \<c-r>\<c-p>"

if exists(":term")
    "Shift space can cause the line to clear for some reason (very annoying)
    tnoremap <S-Space> <space>
endif

"When entering cmdline toggle relative-number
augroup relnutoggle
    au!
    autocmd CmdlineEnter * if &filetype !=# "help" | set nornu | redraw | endif
    autocmd CmdlineLeave * if &filetype !=# "help" | set rnu | redraw | endif
augroup END

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
    \ [ 0xe700, 0xe7c5, 2 ],
    \ [ 0xf0001, 0xf1af0, 2 ],
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
