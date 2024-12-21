vim.fn.setenv("NVIM", vim.v.servername)

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item, opts)
    local expanded = vim.fn.expand(item)
    local fullPath = ""

    --if url
    if item:find("^%w+://") then
        fullPath = item
    --if absolute
    elseif vim.startswith(expanded, "~") or
        vim.startswith(expanded, "/")
    then
        fullPath = expanded
    --otherwise normalize
    else
        -- this should not be the default way to merge paths lmao
        fullPath = vim.fs.normalize(
                vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":p")
                ..
                vim.fn.expand(item)
        )
    end

    local cmd = {"linkhandler"}
    if opts ~= nil and opts.cmd ~= nil then
        ---@type string[]
        cmd = opts.cmd
    end

    cmd[#cmd+1] = fullPath
    vim.system(cmd)
end

vim.ui.select = require "mini.pick".ui_select

-- vim.notify = require"notify"


vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_transparency = 0.7
