local clrGroup = vim.api.nvim_create_augroup("conf-colorscheme", { clear = true })

vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = clrGroup,

    command = "colorscheme vim",
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = clrGroup,

    callback = function()
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "#161b2f" })

        vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "TelescopeMatching" })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction", { link = "@function" })
        vim.api.nvim_set_hl(0, "CmpItemKindField", { link = "@field" })
        vim.api.nvim_set_hl(0, "CmpItemKindOperator", { link = "@operator" })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { link = "@keyword" })
        vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { link = "@lsp.type.enumMember" })
        vim.api.nvim_set_hl(0, "CmpItemKindEnum", { link = "@lsp.type.enum" })
        vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true })
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment" })

        vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 100 })
        vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "NONE", italic = true, fg = "#6e738d" })

        vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

        vim.api.nvim_set_hl(0, "User1", { link = "@label" })
        vim.api.nvim_set_hl(0, "User2", { link = "@namespace" })
        vim.api.nvim_set_hl(0, "User3", { link = "@property" })
        vim.api.nvim_set_hl(0, "User4", { link = "@number" })
        vim.api.nvim_set_hl(0, "User5", { link = "Error" })
        vim.api.nvim_set_hl(0, "User6", { link = "DiagnosticWarning" })

        vim.api.nvim_set_hl(0, "Normal", { background = "#161b2f" })
        vim.api.nvim_set_hl(0, "Normal", { background = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC", { background = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { background = "NONE" })

        -- vim.api.nvim_set_hl(0, "LineNr", { foreground = "#1e2030" })

        vim.api.nvim_set_hl(0, "NotifyBackground", { background = "#000000" })

        for _, toclr in pairs({
            "@lsp.type.function",
            "@lsp.type.method",
            "@keyword.operator",
            "@keyword.function",
            "@property",
            "@variable",
            "@function.call",
            "@function.method.call",
            "@lsp.typemod.function.defaultLibrary"
        }) do
            vim.api.nvim_set_hl(0, toclr, {})
        end

        vim.api.nvim_set_hl(0, "@variable.member", { link = "@variable" })
        vim.api.nvim_set_hl(0, "@variable.builtin", { link = "@variable" })
        vim.api.nvim_set_hl(0, "@variable.parameter", { link = "@variable" })

        vim.api.nvim_set_hl(0, "Boolean", { link = "Number" })

        vim.api.nvim_set_hl(0, "Normal", { fg="#eeeeee"})
        vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "Comment", {fg = "#589353", italic = true})

        -- vim.api.nvim_set_hl(0, "ColorColumn", { link = "DiagnosticVirtualTextWarn" })

        --this modifies the highlight, but vim.api.nvim_set_hl overwrites it
        vim.cmd [[
        hi! DiagnosticUnderlineError gui=underline
        hi! DiagnosticUnderlineWarn gui=underline
        hi! DiagnosticUnderlineInfo gui=underline
        hi! DiagnosticUnderlineHint gui=underline
        hi! DiagnosticUnderlineOk gui=underline

        hi! link @class Type
        hi! link @property @variable
        hi! link @type.builtin Type
        hi! link @keyword.operator Operator
        hi! link @keyword.function Keyword
        hi! link @variable Normal
        "hi Delimiter guifg=#7ec9d8

    ]]

        --better quickfix{{{
        vim.api.nvim_set_hl(0, "BqfPreviewFloat", { background = "#161b2f" })
        --}}}
    end
})

-- vim.cmd.color("monokai-pro-default")
-- vim.cmd.color("onenord")
-- vim.cmd.color("evangelion")
-- vim.cmd[[color tokyonight]]
vim.cmd [[color catppuccin]]
-- Color("tokyonight-moon")
-- Color("monet")
-- Color("kanagawa")
