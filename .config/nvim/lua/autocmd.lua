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
        ks("n", "gd", vim.lsp.buf.definition, { desc = "goto definition" })
        local key_maps = {
            { "<leader>fs", '<cmd>Telescope lsp_document_symbols<cr>',  { desc = "[TELESCOPE] document symbols" } },
            { "gns",        vim.lsp.buf.document_symbol,                { desc = "[QF] Document symbols" } },
            { "gnw",        vim.lsp.buf.workspace_symbol,               { desc = "[QF] Workspace symbols" } },
            { "gnr",        vim.lsp.buf.references,                     { desc = "[QF] References" } },
            { "gno",        vim.lsp.buf.outgoing_calls,                 { desc = "[QF] Outgoing calls" } },
            { "gni",        vim.lsp.buf.incoming_calls,                 { desc = "[QF] Incoming calls" } },
            { "<leader>fS", '<cmd>Telescope lsp_workspace_symbols<cr>', { desc = "[TELESCOPE] Workspace symbols" } },
            { "<leader>fr", vim.lsp.buf.references,                     { desc = "[TELESCOPE] References" } },
            { "<leader>E", function()
                vim.diagnostic.setqflist()
            end, { desc = "[QF] Diagnostics" } },
            { "<leader>r", ":IncRename ",                           { desc = "Incremental rename" } },
            { "<leader>el", function()
                local virt_text = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({ virtual_text = not virt_text })
            end, { desc = "Toggle virtual text" } },
            { "<a-e>",     vim.diagnostic.open_float,               { desc = "Show diagnostics" } },
            --{ "glh",       vim.lsp.buf.hover }, commenting out to force myself to use K
            { "<leader>a", vim.lsp.buf.code_action, { desc = "Select code action to perform" } },
            { "<leader>A", function()
                local n = 0
                vim.lsp.buf.code_action({
                    filter = function()
                        n = n + 1
                        return n == 1
                    end,
                    apply = true
                })
            end, { desc = "Perform first code action automatically" }
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
            end, { desc = "Go to previous diagnostic error" }
            },
            { "<leader>K", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end,
                { desc = "Toggle inlay hints" } },
            { "gK",     vim.diagnostic.open_float,                                        { desc = "Open diagnostic float" } },
            { "g<c-]>", function() vim.lsp.buf.type_definition({ reuse_win = true }) end, { desc = "Go to type definition" } },
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
            end, { desc = "Go to next diagnostic error" }
            },
            {
                "<leader>=",
                function()
                    vim.lsp.buf.format { async = true }
                end, { desc = "Format code" }
            },
        }
        for _, value in ipairs(key_maps) do
            ks("n", value[1], value[2], value[3] or {})
        end
        ks("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "Show function signature" })
    end
})

-- vim.api.nvim_create_autocmd({"ModeChanged"}, {
--     pattern = "*:*",
--     callback = function ()
--         vim.o.titlestring = "nvim - " .. vim.fn.mode()
--     end
-- })
