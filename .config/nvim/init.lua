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

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

require 'plugins'
require 'snippets'
require "options"
require "shortcuts"
require 'autocmd'
require 'functions'
require "user.init"

vim.fn.setenv("IN_VIM", "true")

-- require "filetypes"

local cs = require 'colorscheme'

cs.changeColorScheme({scheme = "catppuccin-macchiato"})

vim.diagnostic.config({ virtual_text = true })

vim.o.winbar = "%{%v:lua.Winbar()%}"

if vim.g.neovide ~= nil then
    vim.g.neovide_transparency = 0.8
    vim.api.nvim_cmd({
        cmd = "hi",
        args = { "Normal", "guibg=NONE", "ctermbg=NONE" }
    }, {})
end

if vim.g.started_by_firenvim then
    vim.o.laststatus = 0
    vim.g.html_font = "Consolas"
end
vim.w.euro_debug_mode = false

vim.lsp.buf.hover = function ()
    vim.api.nvim_cmd({
        cmd = "LspUI",
        args = {"hover"}
    }, {})
end
