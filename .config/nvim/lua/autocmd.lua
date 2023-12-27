vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200, higroup = "RedrawDebugNormal" })
    end
})

-- vim.api.nvim_create_autocmd({"ModeChanged"}, {
--     pattern = "*:*",
--     callback = function ()
--         vim.system({
--             "notify-send",
--             vim.fn.mode()
--         })
--
--         vim.o.titlestring = "nvim - " .. vim.fn.mode()
--     end
-- })
--         vim.o.title = true

-- I cannot STAND inlay hints in insert mode
-- vim.api.nvim_create_autocmd("InsertEnter", {
--     callback = function()
--         vim.lsp.inlay_hint(0, false)
--     end
-- })
-- vim.api.nvim_create_autocmd("InsertLeave", {
--     callback = function ()
--         vim.lsp.inlay_hint(0, true)
--     end
-- })
