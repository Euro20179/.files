vim.fn.setenv("IN_VIM", "true")

vim.fn.setenv("NVIM", vim.v.servername)

vim.g._outline_cmd = "SymbolsOutline"

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item)
    vim.system({ "linkhandler", item })
end

vim.ui.select = require "mini.pick".ui_select
