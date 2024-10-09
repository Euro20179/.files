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
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
                border = "single",
                title = "hover"
            }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
                border = "single",
                title = "signature"
            }
        )

        vim.diagnostic.config({
            float = {
                border = "single",
                title = "diagnostic"
            }
        })

        local ks = vim.keymap.set
        ks("n", "gd", vim.lsp.buf.definition, { desc = "[LSP] goto definition" })
        local key_maps = {
            { "gls",  vim.lsp.buf.document_symbol,  { desc = "[LSP] [QF] Document symbols" } },
            { "glw", vim.lsp.buf.workspace_symbol, { desc = "[LSP] [QF] Workspace symbols" } },
            { "glo", vim.lsp.buf.outgoing_calls,   { desc = "[LSP] [QF] Outgoing calls" } },
            { "gli", vim.lsp.buf.incoming_calls,   { desc = "[LSP] [QF] Incoming calls" } },
            { "glm", vim.lsp.buf.implementation,   { desc = "[LSP] [QF] Implementations" } },
            { "glr", vim.lsp.buf.references,      { desc = "[LSP] [QF] References" } },
            { "glh", function()
                vim.ui.select({ "Parents", "Children" }, {}, function(choice)
                    if choice == "Parents" then
                        vim.lsp.buf.typehierarchy("supertypes")
                    else
                        vim.lsp.buf.typehierarchy("subtypes")
                    end
                end)
            end, { desc = "[LSP] [QF] Type heirarchy" } },
            { "crn",   vim.lsp.buf.rename,        { desc = "[LSP] Rename Symbol" } },
            { "<leader>ea", function()
                vim.diagnostic.setqflist()
            end, { desc = "[QF] Diagnostics ALL" } },
            { "<leader>ee", function()
                vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
            end, { desc = "[QF] Diagnostics ERROR" } },
            { "<leader>ew", function()
                vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
            end, { desc = "[QF] Diagnostics WARN" } },
            { "<leader>ei", function()
                vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.INFO })
            end, { desc = "[QF] Diagnostics INFO" } },
            { "<leader>eh", function()
                vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.HINT })
            end, { desc = "[QF] Diagnostics HINT" } },
            { "<leader>el", function()
                local virt_text = vim.diagnostic.config().virtual_text
                vim.diagnostic.config({ virtual_text = not virt_text })
            end, { desc = "[LSP] Toggle virtual text" } },
            { "<a-e>", vim.diagnostic.open_float, { desc = "[LSP] Show diagnostics" } },
            { "cra",   vim.lsp.buf.code_action,   { desc = "[LSP] Select code action to perform" } },
            { "crA", function()
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
            { "<leader>K", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }),
                    { bufnr = 0 }) end,
                { desc = "[LSP] Toggle inlay hints" } },
            { "gK",     "<c-w>d",                                                         { desc = "[LSP] Open diagnostic float", remap = true } },
            { "g<c-]>", function() vim.lsp.buf.type_definition({ reuse_win = true }) end, { desc = "[LSP] Go to type definition" } },
            { "[e", function()
                vim.diagnostic.goto_prev({
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]e", function()
                vim.diagnostic.goto_next({
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto next error" } },
            { "[w", function()
                vim.diagnostic.goto_prev({
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]w", function()
                vim.diagnostic.goto_next({
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto next error" } },
            { "[D", function()
                vim.diagnostic.goto_prev()
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

        ks("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
    end
})

-- vim.api.nvim_create_autocmd({"ModeChanged"}, {
--     pattern = "*:*",
--     callback = function ()
--         vim.o.titlestring = "nvim - " .. vim.fn.mode()
--     end
-- })
