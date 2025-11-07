local aug = vim.api.nvim_create_augroup("conf.vimwiki", {})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local bufn = vim.fn.expand("%:p")
        if not bufn:match(".*vimwiki.*") then
            return
        end

        local pkg = require "pkg"

        pkg.add({
            {
                src = "https://github.com/nvim-tree/nvim-tree.lua"
            }
        }, "now", {
            on_add = function()
                require "nvim-tree".setup {}
                    vim.cmd[[
                        NvimTreeOpen
                        wincmd l
                    ]]
            end
        })
    end,
    once = true,
    buffer = 0
})
