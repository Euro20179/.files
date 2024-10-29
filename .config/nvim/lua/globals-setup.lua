vim.fn.setenv("NVIM", vim.v.servername)

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item)
    vim.system({ "linkhandler", item })
end

vim.ui.select = require "mini.pick".ui_select

-- vim.notify = require"notify"

vim.g.clipboard = {
    name = "test",
    copy = {
        ["+"] = 'wl-copy',
        ["*"] = 'wl-copy -p'
    },
    paste = {
        ["+"] = 'wl-paste',
        ["*"] = 'wl-paste -p'
    }
}

vim.g.neovide_cursor_animation_length = 0
