local _M = {}

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

_M.changeColorScheme = function(newScheme)
    vim.api.nvim_cmd({
        args = { newScheme.scheme },
        cmd = "colorscheme"
    }, {})
    vim.cmd[[hi Normal guibg=#00000000]]
    vim.api.nvim_set_hl(0, "LspInlayHint", {bg = "NONE", italic = true, fg="#6e738d"})
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true})
end

return _M
