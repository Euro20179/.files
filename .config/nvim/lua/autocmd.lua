vim.api.nvim_create_autocmd("BufReadPost,BufNewFilePost", {
    pattern = "*.norg",
    callback = function()
        vim.api.nvim_cmd({
            cmd = "norm",
            args = { "zR" }
        }, {})
    end
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        pcall(DisplayImg)
    end
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200, higroup = "RedrawDebugNormal" })
    end
})
