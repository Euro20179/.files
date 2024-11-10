function ExecSelection(cmdData)
    local lines
    if #cmdData.fargs ~= 0 then
        lines = { table.concat(cmdData.fargs, " ") }
    else
        lines = vim.api.nvim_buf_get_lines(0, cmdData.line1 - 1, cmdData.line2, false)
    end
    if cmdData.bang then
        vim.cmd["!"](table.concat(lines, ";"))
    else
        GotoTerminalBuf()
        vim.api.nvim_feedkeys('i' .. table.concat(lines, "\n") .. "\n", "n", false)
    end
end

vim.api.nvim_create_user_command("Exec", ExecSelection, { range = true, nargs = "?", bang = true })
