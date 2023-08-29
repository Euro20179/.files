-- vim.api.nvim_create_autocmd("VimEnter,TabNew", {
--     desc = "Sidebars",
--     callback = function()
--         if vim.g.euro_is_manpage == nil and vim.g.started_by_firenvim == nil then
--             vim.cmd [[UndotreeToggle | wincmd p | wincmd j | vertical-resize 20 | wincmd q | wincmd L | exe "normal 20\<C-w>|" | wincmd h]]
--         end
--     end
-- })


vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
    pattern = "*.bircle",
    callback = function()
        vim.opt.filetype = "bircle"
    end
})

-- vim.api.nvim_create_autocmd("BufReadPost,BufNewFilePost", {
--     pattern = "/home/euro/Programs/Coding Projects/JS Things/bircle/index.ts",
--     callback = function()
--         vim.cmd[[:TSDisable highlight]]
--     end
-- })

vim.api.nvim_create_autocmd("BufReadPost,BufNewFilePost", {
    pattern = "*.norg",
    callback = function()
        vim.cmd [[:norm zR]]
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local filetypeMatches = {
            lua = "if:end,function:end",
            sh = "if:fi,while:done,for:done,until:done,case:esac"
        }
        local matches = filetypeMatches[vim.bo.filetype]
        if matches then
            vim.b.match_words = matches
        end
    end,
    once = true
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*.email",
    callback = function()
        vim.opt.filetype = 'email'
    end
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200, higroup = "RedrawDebugNormal" })
    end
})
