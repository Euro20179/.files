-- colorscheme.after = function()
-- vim.cmd [[
-- " for vscode looking completion
--  " highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
--  " " blue
--  " highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
--  " highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
--  " " light blue
--  " highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
--  " highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
--  " highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
--  " " pink
--  " highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
--  " highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
--  " " front
--  " highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
--  " highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
--  " highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
--
-- "for tokyonight-moon change back if looks bad with other schemes
-- highlight! link TabLine Normal
-- ]]
--     -- vim.cmd [[
--     -- highlight! PmenuSel guibg=#282C34 guifg=NONE
--     -- highlight! Pmenu guifg=#C5CDD9 guibg=#22252A
--     --
--     -- highlight! CmpItemAbbrDeprecated guifg=#7E8294 guibg=NONE
--     -- highlight! CmpItemAbbrMatch guifg=#82AAFF guibg=NONE
--     -- highlight! CmpItemAbbrMatchFuzzy guifg=#82AAFF guibg=NONE
--     -- highlight! CmpItemMenu guifg=#C792EA guibg=NONE
--     --
--     -- highlight! CmpItemKindField guifg=#EED8DA guibg=#B5585F
--     -- highlight! CmpItemKindProperty guifg=#EED8DA guibg=#B5585F
--     -- highlight! CmpItemKindEvent guifg=#EED8DA guibg=#B5585F
--     --
--     -- highlight! CmpItemKindText guifg=#ffffff guibg=#9FBD73
--     -- highlight! CmpItemKindEnum guifg=#ffffff guibg=#9FBD73
--     -- highlight! CmpItemKindKeyword guifg=#ffffff guibg=#9FBD73
--     --
--     -- highlight! CmpItemKindConstant guifg=#ffffff guibg=#D4BB6C
--     -- highlight! CmpItemKindConstructor guifg=#ffffff guibg=#D4BB6C
--     -- highlight! CmpItemKindReference guifg=#ffffff guibg=#D4BB6C
--     --
--     -- highlight! CmpItemKindFunction guifg=#ffffff guibg=#A377BF
--     -- highlight! CmpItemKindStruct guifg=#ffffff guibg=#A377BF
--     -- highlight! CmpItemKindClass guifg=#ffffff guibg=#A377BF
--     -- highlight! CmpItemKindModule guifg=#ffffff guibg=#A377BF
--     -- highlight! CmpItemKindOperator guifg=#ffffff guibg=#A377BF
--     --
--     -- highlight! CmpItemKindVariable guifg=#ffffff guibg=#7E8294
--     -- highlight! CmpItemKindFile guifg=#ffffff guibg=#7E8294
--     --
--     -- highlight! CmpItemKindUnit guifg=#ffffff guibg=#D4A959
--     -- highlight! CmpItemKindSnippet guifg=#ffffff guibg=#D4A959
--     -- highlight! CmpItemKindFolder guifg=#ffffff guibg=#D4A959
--     --
--     -- highlight! CmpItemKindMethod guifg=#ffffff guibg=#6C8ED4
--     -- highlight! CmpItemKindValue guifg=#ffffff guibg=#6C8ED4
--     -- highlight! CmpItemKindEnumMember guifg=#ffffff guibg=#6C8ED4
--     --
--     -- highlight! CmpItemKindInterface guifg=#ffffff guibg=#58B5A8
--     -- highlight! CmpItemKindColor guifg=#ffffff guibg=#58B5A8
--     -- highlight! CmpItemKindTypeParameter guifg=#ffffff guibg=#58B5A8
--     -- ]]
-- end
--

function Color(scheme)
    --for legacy colorschemes
    vim.api.nvim_cmd({
        args = { "vim" },
        cmd = "colorscheme"
    }, {})

    vim.api.nvim_cmd({
        -- args = { 'nord' },
        -- args = { "catppuccin-macchiato" },
        args = { scheme },
        -- args = { "candy" },
        cmd = "colorscheme"
    }, {})

    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#161b2f" })

    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "TelescopeMatching" })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { link = "function" })
    vim.api.nvim_set_hl(0, "CmpItemKindField", { link = "field" })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { link = "operator" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { link = "keyword" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { link = "enumMember" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { link = "enum" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", blend = 100 })
    vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "NONE", italic = true, fg = "#6e738d" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true })

    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

    vim.api.nvim_set_hl(0, "User1", { link = "@label" })
    vim.api.nvim_set_hl(0, "User2", { link = "@namespace" })
    vim.api.nvim_set_hl(0, "User3", { link = "@property" })
    vim.api.nvim_set_hl(0, "User4", { link = "@number" })
    vim.api.nvim_set_hl(0, "User5", { link = "Error" })
    vim.api.nvim_set_hl(0, "User6", { link = "DiagnosticWarning" })

    vim.api.nvim_set_hl(0, "Normal", { background = "#161b2f" })
    -- vim.api.nvim_set_hl(0, "Normal", { background = "NONE" })
    -- vim.api.nvim_set_hl(0, "NormalNC", { background = "NONE" })

    --better quickfix{{{
    vim.api.nvim_set_hl(0, "BqfPreviewFloat", { background = "#161b2f" })
    --}}}

    if vim.g.neovide ~= nil then
        vim.g.neovide_transparency = 0.8
        vim.api.nvim_cmd({
            cmd = "hi",
            args = { "Normal", "guibg=NONE", "ctermbg=NONE" }
        }, {})
    end
end

--Color("tokyonight-moon")
Color("catppuccin-macchiato")
-- Color("kanagawa")
