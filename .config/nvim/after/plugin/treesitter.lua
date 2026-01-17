vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        require "nvim-treesitter.parsers".mmfml = {
            install_info = {
                url = "https://github.com/euro20179/treesitter-mmfml",
                revision = "master",
            }
        }
        require "nvim-treesitter.parsers".amml = {
            install_info = {
                url = "https://github.com/euro20179/treesitter-amml",
                revision = "master",
            }
        }
    end
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        require "nvim-treesitter".setup {
            textobjects = {
                enable = true,
                lookahead = true,
            }
        }
        pcall(vim.treesitter.start)
    end
})

vim.treesitter.language.register("mmfml", { "mmfml" })

for key, select in pairs({
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["a;"] = "@statement.outer",
    ["i,"] = "@parameter.inner",
    ["a,"] = "@parameter.outer",
    ["a="] = "@assignment.lhs",
    ["i="] = "@assignment.rhs",
}) do
    vim.keymap.set({"x", "o"}, key, function()
        require"nvim-treesitter-textobjects.select".select_textobject(select, "textobjects")
    end)
end
