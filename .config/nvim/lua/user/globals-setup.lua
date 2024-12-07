vim.fn.setenv("NVIM", vim.v.servername)

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item)
    vim.system({ "linkhandler", item })
end

vim.ui.select = require "mini.pick".ui_select

-- vim.notify = require"notify"


vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_transparency = 0.7
