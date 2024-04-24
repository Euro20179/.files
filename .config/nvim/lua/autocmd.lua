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
    callback = function()
        local ks = vim.keymap.set
        ks("n", "gd", vim.lsp.buf.definition, { desc = "[LSP] goto definition" })
        local key_maps = {
            { "<leader>fs", vim.lsp.buf.document_symbol,                     { desc = "[LSP] [QF] document symbols" } },
            { "gss",        vim.lsp.buf.document_symbol,                     { desc = "[LSP] [QF] Document symbols" } },
            { "gsw",        vim.lsp.buf.workspace_symbol,                    { desc = "[LSP] [QF] Workspace symbols" } },
            { "gsr",        vim.lsp.buf.references,                          { desc = "[LSP] [QF] References" } },
            { "gso",        vim.lsp.buf.outgoing_calls,                      { desc = "[LSP] [QF] Outgoing calls" } },
            { "gsi",        vim.lsp.buf.incoming_calls,                      { desc = "[LSP] [QF] Incoming calls" } },
            { "<leader>fS", function() vim.lsp.buf.workspace_symbol("") end, { desc = "[LSP] [QF] Workspace symbols" } },
            { "<leader>fr", vim.lsp.buf.references,                          { desc = "[LSP] [QF] References" } },
            { "<leader>E", function()
                vim.diagnostic.setqflist()
            end, { desc = "[QF] Diagnostics" } },
            { "<leader>r", ":IncRename ",             { desc = "Incremental rename" } },
            { "<leader>el", function()
                local virt_text = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({ virtual_text = not virt_text })
            end, { desc = "Toggle virtual text" } },
            { "<a-e>",     vim.diagnostic.open_float, { desc = "[LSP] Show diagnostics" } },
            --{ "glh",       vim.lsp.buf.hover }, commenting out to force myself to use K
            { "<leader>a", vim.lsp.buf.code_action,   { desc = "[LSP] Select code action to perform" } },
            { "<leader>A", function()
                local n = 0
                vim.lsp.buf.code_action({
                    filter = function()
                        n = n + 1
                        return n == 1
                    end,
                    apply = true
                })
            end, { desc = "[LSP] Perform first code action automatically" }
            },
            { "]D", function()
                vim.diagnostic.goto_next()
                local n = 0
                vim.lsp.buf.code_action({
                    filter = function()
                        n = n + 1
                        return n == 1
                    end,
                    apply = true
                })
            end, { desc = "[LSP] Go to previous diagnostic error" }
            },
            { "<leader>K", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(0), { bufnr = 0 }) end,
                { desc = "[LSP] Toggle inlay hints" } },
            { "gK",     vim.diagnostic.open_float,                                        { desc = "[LSP] Open diagnostic float" } },
            { "g<c-]>", function() vim.lsp.buf.type_definition({ reuse_win = true }) end, { desc = "[LSP] Go to type definition" } },
            { "[e", function ()
                vim.diagnostic.goto_prev({
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]e", function ()
                vim.diagnostic.goto_next({
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto next error" } },
            { "[w", function ()
                vim.diagnostic.goto_prev({
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]w", function ()
                vim.diagnostic.goto_next({
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto next error" } },
            { "[D", function()
                vim.diagnostic.goto_prev({})
                local n = 0
                vim.lsp.buf.code_action({
                    filter = function(_)
                        n = n + 1
                        return n == 1
                    end,
                    apply = true
                })
            end, { desc = "[LSP] Go to next diagnostic error" }
            },
            {
                "<leader>=",
                function()
                    vim.lsp.buf.format { async = true }
                end, { desc = "[LSP] Format code" }
            },
        }
        for _, value in ipairs(key_maps) do
            ks("n", value[1], value[2], value[3] or {})
        end
        ks("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "[LSP] Show function signature" })
    end
})

-- vim.api.nvim_create_autocmd({"ModeChanged"}, {
--     pattern = "*:*",
--     callback = function ()
--         vim.o.titlestring = "nvim - " .. vim.fn.mode()
--     end
-- })
