vim.o.splitbelow = true
vim.o.splitright = true
vim.o.dictionary = "/usr/share/dict/american-english"
vim.o.nu = true
vim.o.rnu = true
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.ruler = true
vim.o.swapfile = false
vim.o.foldmethod = "marker"
vim.o.smartcase = true
vim.o.scbk = 100
vim.o.tildeop = true
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.opt.display:append("uhex")
vim.o.formatoptions = "jql"
vim.o.expandtab = true
vim.o.concealcursor = ''
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.spelllang =  "en_us"
-- vim.o.spell = true
vim.opt.fillchars = {eob = "󰅖"}
--fixes weird bug with Telescope help_menu tags not being sorted and lazy complaining
vim.o.tagcase = 'ignore'
vim.o.lazyredraw = true

vim.o.exrc = true

vim.o.smoothscroll = true
vim.o.conceallevel = 2

vim.o.pumblend = 5

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = "v:lua.vim.treesitter.foldtext()"

vim.o.winbar = "%{%v:lua.Winbar()%}"
