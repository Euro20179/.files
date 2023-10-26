vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200, higroup = "RedrawDebugNormal" })
    end
})
--
-- vim.api.nvim_create_autocmd("NeoTreeFileNameOpened", {
--     callback = function(data)
--         vim.print(data)
--     end
-- })
