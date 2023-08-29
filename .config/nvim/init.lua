
-- lazy bootstrap{{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)
-- }}}

require 'plugins'

require 'snippets'
require "options"
require "shortcuts"
require 'autocmd'
require 'functions'
require "user.init"

local cs = require 'colorscheme'

cs.changeColorScheme({scheme = "catppuccin"})

require "lsp_signature".setup({
    bind = true,
    hint_enable = true,
    hint_prefix = " ",
    always_trigger = false,
    floating_window = false
})

vim.diagnostic.config({ virtual_text = false })

vim.o.winbar = "%{%v:lua.Winbar()%}"

if vim.g.neovide ~= nil then
    vim.g.neovide_transparency = 0.8
    vim.api.nvim_cmd({
        cmd = "hi",
        args = { "Normal", "guibg=NONE", "ctermbg=NONE" }
    }, {})
end

--vim.highlight.on_yank({ timeout = 200, higroup = "String" })

--vim.notify = require("notify")

if vim.g.started_by_firenvim then
    vim.o.laststatus = 0
    vim.g.html_font = "Consolas"
end

vim.w.euro_debug_mode = false

-- if vim.g.euro_is_manpage ~= nil then
-- end
