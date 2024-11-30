function LazyGitTerm()
    local buf = vim.api.nvim_create_buf(true, false)

    local width = vim.fn.round(vim.o.columns / 1.2)
    local height = vim.o.lines - 4

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = height,
        col = (vim.o.columns - width) / 2,
        border = "double",
        title = "[LAZYGIT]",
        focusable = true
    })

    vim.wo[win].number = false
    vim.wo[win].relativenumber = false

    vim.fn.termopen("lazygit", {
        on_exit = function()
            vim.api.nvim_buf_delete(buf, { force = true })
        end,
    })

    --get the user in insert mode in the terminal
    vim.api.nvim_feedkeys("i", "n", false)
end

vim.keymap.set("n", "<leader>G", LazyGitTerm, { desc = "[GIT]: Open lazygit in nvim term" })
