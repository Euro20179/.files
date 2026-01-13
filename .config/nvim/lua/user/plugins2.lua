vim.o.pp = vim.o.pp .. ',' .. vim.fn.expand("$HOME/Programs/Coding Projects/neovim-plugins")


-- mmfml plugin can be found: https://static.seceurity.place/git/nvim-mmfml
-- gemini plugin can be found: https://github.com/euro20179/nvim-gemini
-- div can be found: https://github.com/Euro20179/div.nvim
for _, plug in pairs({
    "nvim.difftool",
    "nvim.undotree",
    "mmfml",
    "gemini",
    "div",
    "find-highlight",
    "discord",
    "discord-ui",
    "irc.nvim",
    "enc-notes"
}) do
    -- :packadd! = do not source plugin/*
    -- because plug is added to &rtp meaning it will get sourced anyway
    vim.cmd.packadd { plug, bang = true }
end

vim.pack.add({
    --- deps {{{
    { src = "https://github.com/3rd/sqlite.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim", },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    --- }}}

    -- Treesitter{{{
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        rev = "main",
        branches = { "main" },
        version = "main"
    },
    -- }}}

    --LSP+DAP{{{
    { src = "https://github.com/b0o/Schemastore.nvim" },
    { src = "https://github.com/icholy/lsplinks.nvim" },
    { src = "https://github.com/Saghen/blink.cmp" },
    { src = "https://github.com/williamboman/mason.nvim" },
    --- }}}

    -- Themes {{{
     { src = "https://github.com/catppuccin/nvim"  },
    -- }}}

    -- Navigation {{{
    { src = "https://github.com/kevinhwang91/nvim-bqf" },
    { src = "https://github.com/stevearc/oil.nvim" },
    -- }}}

    { src = "https://github.com/echasnovski/mini.nvim" },

    { src = "https://github.com/wakatime/vim-wakatime" },

    { src = "https://github.com/Apeiros-46B/qalc.nvim", version = "451f082" },

    { src = "https://github.com/tpope/vim-fugitive" },
})
