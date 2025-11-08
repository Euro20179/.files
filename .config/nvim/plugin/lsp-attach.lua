local conf_group = vim.api.nvim_create_augroup("config.lsp-attach", {
    clear = true
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = conf_group,
    callback = function()
        vim.lsp.document_color.enable(true)
        -- vim.lsp.inlay_hint.enable(true)

        vim.diagnostic.config({
            float = {
                border = "single",
                title = "diagnostic"
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    [vim.diagnostic.severity.HINT] = ""
                }
            }
        })


        local ks = vim.keymap.set
        local key_maps = {
            { "[i", function()
                vim.lsp.buf.definition({
                    on_list = function (opts)
                        vim.print(vim.fn.getline(opts["items"][1]["lnum"]))
                    end
                })
            end },
            { "glc", vim.lsp.document_color.color_presentation, { desc = "[LSP] Color representation" } },
            { "gls",  "gO",  { desc = "[LSP] [QF] Document symbols", remap = true } },
            { "glw", vim.lsp.buf.workspace_symbol, { desc = "[LSP] [QF] Workspace symbols" } },
            { "glo", vim.lsp.buf.outgoing_calls,   { desc = "[LSP] [QF] Outgoing calls" } },
            { "gli", vim.lsp.buf.incoming_calls,   { desc = "[LSP] [QF] Incoming calls" } },
            { "glm", "gri",   { desc = "[LSP] [QF] Implementations", remap = true } },
            { "glr", "grr",      { desc = "[LSP] [QF] References", remap = true } },
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
            { "<c-n>", function ()
                GotoNthRelativeReference(1)
            end, { desc = "[LSP]: Jump to the next reference" } },
            { "<c-p>", function ()
                GotoNthRelativeReference(-1)
            end, { desc = "[LSP]: Jump to the previous reference" } },
            { "<a-e>", vim.diagnostic.open_float, { desc = "[LSP] Show diagnostics" } },
            { "cra",   "gra",   { desc = "[LSP] Select code action to perform", remap = true } },
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
                vim.diagnostic.jump({ count = 1, pos = vim.api.nvim_win_get_cursor(0) })
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
                vim.diagnostic.jump({
                    count = -1,
                    pos = vim.api.nvim_win_get_cursor(0),
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]e", function()
                vim.diagnostic.jump({
                    count = 1,
                    pos = vim.api.nvim_win_get_cursor(0),
                    severity = vim.diagnostic.severity.ERROR
                })
            end, { desc = "[LSP] goto next error" } },
            { "[w", function()
                vim.diagnostic.jump({
                    count = -1,
                    pos = vim.api.nvim_win_get_cursor(0),
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto previous error" } },
            { "]w", function()
                vim.diagnostic.jump({
                    count = 1,
                    pos = vim.api.nvim_win_get_cursor(0),
                    severity = vim.diagnostic.severity.WARN
                })
            end, { desc = "[LSP] goto next error" } },
            { "[D", function()
                vim.diagnostic.jump({
                    count = -1,
                    pos = vim.api.nvim_win_get_cursor(0),
                })
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
    end
})
