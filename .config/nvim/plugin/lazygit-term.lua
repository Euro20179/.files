function LazyGitTerm()
    local jid = nil

    local buf = vim.api.nvim_create_buf(true, false)
    local term = vim.api.nvim_open_term(buf, {
        on_input = function(_, _, _, data)
            ---@diagnostic disable-next-line: invisible
            pcall(vim.api.nvim_chan_send, jid, data)
        end,
    })

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

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        once = true,
        callback = function ()
            --simulate the user quitting
            --when the user exits the lazygit term buf
            vim.api.nvim_chan_send(jid, "q")
        end
    })

    vim.wo[win].number = false
    vim.wo[win].relativenumber = false

    --get the user in insert mode in the terminal
    vim.api.nvim_feedkeys("i", "n", false)

    jid = vim.fn.jobstart("lazygit", {
        pty = true,
        height = height,
        width = width,
        on_exit = function()
            vim.api.nvim_buf_delete(buf, { force = true })
            ---@diagnostic disable-next-line
            vim.fn.jobstop(jid)
        end,
        on_stdout = function(num, data)
            vim.schedule(function()
                -- vim.print(data)
                vim.api.nvim_chan_send(term, vim.fn.join(data, "\n"))
            end)
        end
    })
end
