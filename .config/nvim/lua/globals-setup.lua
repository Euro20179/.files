vim.fn.setenv("IN_VIM", "true")

vim.fn.setenv("NVIM", vim.v.servername)

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item)
    vim.system({ "linkhandler", item })
end

vim.ui.select = require "mini.pick".ui_select

-- vim.notify = require"notify"

-- turn the * register into a calculator register that reads/writes to system clipboard
vim.g.clipboard = {
    name = "test",
    copy = {
        ["+"] = 'wl-copy',
        ["*"] = function(lines)
            local o = vim.system({"qalc", "-t", table.concat(lines, "\n")}):wait()
            vim.system({"wl-copy"}, {
                stdin = o.stdout
            })
        end
    },
    paste = {
        ["+"] = 'wl-paste',
        ["*"] = function()
            local o = vim.system({"wl-paste"}):wait()
            local qo = vim.system({"qalc", "-t", o.stdout}):wait()
            return { vim.trim(qo.stdout) }
        end
    }
}
