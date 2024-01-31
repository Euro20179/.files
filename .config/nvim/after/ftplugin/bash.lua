local s = require"nvim-snippets".add_snippet

vim.bo.equalprg = "shfmt"

s(vim.bo.filetype, {
    epic = {
        body = { "ver", "cool" },
        prefix = {"epic"}
    }
})
