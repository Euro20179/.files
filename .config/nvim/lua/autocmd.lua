local conf_group = vim.api.nvim_create_augroup("config", {
    clear = true
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = conf_group,
    callback = function()
        vim.highlight.on_yank({ timeout = 200, higroup = "RedrawDebugNormal" })
    end
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = conf_group,
    callback = function ()
        vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    end
})

-- vim.api.nvim_create_autocmd({"ModeChanged"}, {
--     pattern = "*:*",
--     callback = function ()
--         vim.o.titlestring = "nvim - " .. vim.fn.mode()
--     end
-- })
