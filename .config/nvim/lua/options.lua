vim.g.mapleader = " "

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.dictionary = "/usr/share/dict/american-english"
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ruler = true
vim.opt.swapfile = false
vim.opt.foldmethod = "marker"
vim.opt.smartcase = true
vim.opt.scbk = 100
vim.opt.tildeop = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.display:append("uhex")
vim.opt.formatoptions = "jql"
vim.opt.expandtab = true
vim.opt.concealcursor = ''
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.spelllang = "en_us"
-- vim.o.spell = true
vim.opt.fillchars = { eob = "󰅖" }
--fixes weird bug with Telescope help_menu tags not being sorted and lazy complaining
vim.opt.tagcase = 'ignore'

vim.opt.exrc = true
vim.opt.smoothscroll = true
vim.opt.conceallevel = 2

if vim.g.neovide then
    vim.opt.pumblend = 10
end

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- vim.o.winbar = "%{%v:lua.Winbar()%}"
vim.opt.title = true

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0

vim.opt.grepprg = 'rg -n $*'

vim.opt.wrap = false

vim.opt.colorcolumn = { 100 }

local left = '%1*%f%2*%{&modified == v:true ? "*" : ""} %4*%p%%%*'
local right = '%2*%y'
local center = '%3*%{v:lua.GetLspNames()}%*'

vim.opt.statusline = left .. '%=' .. center .. '%=' .. right

vim.cmd.lang("ja_JP.utf8")
