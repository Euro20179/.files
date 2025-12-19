--[=[
Last Modified 12/19/2025 08:42
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

local sist_process

vim.api.nvim_create_autocmd("VimLeave", {
    group = aug,
    callback = function ()
        if sist_process ~= nil then
            sist_process:kill()
        end
    end
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = aug,
    once = true,
    pattern = vim.fn.expand("$WIKI") .. "/*",
    callback = function()
        sist_process = vim.system({"sist2", "web", "--search-index", vim.fn.expand("$WIKI/.sist2/index.sist2"), vim.fn.expand("$WIKI/.sist2/scan.sist2")})

        vim.keymap.set("n", "<c-s>", ":Search ")

        vim.api.nvim_create_user_command("Search", function(data)
            local search = data.args
            local post_data = {
                query = search,
                sort = "score",
                highlight = true,
                pageSize = 1000,
                indexIds = {1766161970},
            }

            local res = vim.system({"curl", "-X", "POST", "-d", vim.json.encode(post_data), "http://127.0.0.1:4090/fts/search"}):wait()
            if res.code ~= 0 then
                vim.notify("Failed to make query", vim.log.levels.ERROR)
                return
            end

            local res = vim.json.decode(res.stdout)

            local loclist = {}

            local wiki_root = vim.fn.expand("$WIKI")

            for _, hit in pairs(res["hits"]["hits"]) do
                loclist[#loclist+1] =  {
                    filename = wiki_root .. '/' .. hit._source.path .. '/' .. hit._source.name .. '.' .. hit._source.extension,
                    lnum = 1,
                    text = string.gsub(hit.highlight.name, "</?mark>", "")
                }
            end

            vim.fn.setloclist(0, loclist)
            vim.cmd[[lwin]]
        end, {nargs = "*" })
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
