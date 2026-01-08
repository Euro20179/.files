vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate",
    callback = function()
        require"nvim-treesitter.parsers".mmfml = {
            install_info = {
                url = "https://github.com/euro20179/treesitter-mmfml",
                revision = "master",
            }
        }
        require"nvim-treesitter.parsers".amml = {
            install_info = {
                url = "https://github.com/euro20179/treesitter-amml",
                revision = "master",
            }
        }
    end
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo[0].filetype)
        local ok, _ = pcall(vim.treesitter.start, 0, lang)
    end
})

vim.treesitter.language.register("mmfml", { "mmfml" })
