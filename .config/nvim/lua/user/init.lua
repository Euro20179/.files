-- require "user.cmp"
-- require "user.telescope"
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup(
        "euro_treesitter_lazyload",
        { clear = true}
    ),
    once = true,
    callback = function ()
        -- loading treesitter lazily here with vim.schedule
        -- makes it so that parsing + highlights
        -- dont take up half the starting time
        vim.schedule(function()
            require "user.plugin-setup.treesitter"
        end)
    end
})

require 'user.plugin-setup.whichkey'
require "user.plugin-setup.Lspconfig"
-- require "user.plugin-setup.dap"
-- require"user.plugin-setup.lsplinks"
-- require"user.nelisp"
