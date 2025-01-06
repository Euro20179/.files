vim.api.nvim_create_user_command('TermHl', function()
    local b = vim.api.nvim_create_buf(false, true)
    local chan = vim.api.nvim_open_term(b, {})
    vim.api.nvim_chan_send(chan, table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
    vim.api.nvim_win_set_buf(0, b)
end, { desc = 'Highlights ANSI termcodes in curbuf' })

