require 'snippets'
require 'cmp_'
require "options"
require 'plugins'
require "shortcuts"
require 'autocmd'
require 'functions'
require 'Lspconfig'
local cs = require 'colorscheme'
require "impatient"
require "user.init"

cs.changeColorScheme(cs.colorscheme)

vim.api.nvim_cmd({
    args = { "packer.nvim" },
    cmd = "packadd"
}, {})

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
