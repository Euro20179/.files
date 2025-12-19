--[=[
Last Modified 12/19/2025 07:41
Description: Whatever improvements I feel like adding to my vimwiki
--]=]
local aug = vim.api.nvim_create_augroup("conf.vimwiki", {})
vim.api.nvim_create_autocmd("BufNewFile", {
    group = aug,
    pattern = {
        vim.fn.expand("$WIKI") .. "/*.mmfml",
        vim.fn.expand("$WIKI") .. "/*.mfl"
    },
    callback = function()
        vim.cmd[[
        Divl =
        call append(".", "")
        call setpos(".", [0, 2, 0])
        ILastMod
        right
        /=/norm 3O
        call setpos(".", [0, 0, 0])
        ]]
    end
})
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         local bufn = vim.fn.expand("%:p")
--         if not bufn:match(".*vimwiki.*") then
--             return
--         end
--
--         local pkg = require "pkg"
--
--         pkg.add({
--             {
--                 src = "https://github.com/nvim-tree/nvim-tree.lua"
--             }
--         }, "now", {
--             on_add = function()
--                 require "nvim-tree".setup {}
--                     vim.cmd[[
--                         NvimTreeOpen
--                         wincmd l
--                     ]]
--             end
--         })
--     end,
--     once = true,
--     buffer = 0
-- })
