function RenderHTML(renderer, args, newFiletype)
    if renderer == nil then
        args = { "-tgfm", "-fhtml" }
        renderer = "pandoc"
    end

    if renderer == "lynx" and args == nil then
        args = {"-dump", "-force_html" }
    end

    if type(args) ~= "table" then
        vim.notify("args must be a table", vim.log.levels.ERROR)
        return
    end

    newFiletype = newFiletype or "markdown"

    local outFile = vim.fn.tempname()

    local initialFile = vim.fn.tempname()

    local text = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    vim.fn.writefile(text, initialFile)

    local cmd = {renderer}

    for i=1,#args do
        cmd[#cmd + 1] = args[i]
    end

    cmd[#cmd + 1] = initialFile

    vim.print(cmd)
    local out = vim.system(cmd):wait()

    local newBuf = vim.api.nvim_create_buf(true, false)

    vim.fn.writefile(vim.split(out.stdout, "\n"), outFile)

    vim.api.nvim_buf_set_name(newBuf, outFile)
    vim.api.nvim_buf_set_lines(newBuf, 0, -1, false, vim.split(vim.trim(out.stdout), "\n"))
    vim.bo[newBuf].filetype = newFiletype

    vim.api.nvim_win_set_buf(0, newBuf)
end

vim.api.nvim_create_user_command("RenderHTML", function(data)
    if data.args ~= "" then
        local renderer = data.fargs[1]
        local args = {}
        local ft = "markdown"
        for i = 2, #data.fargs do
            if vim.startswith(data.fargs[i], "ft:") then
                ft = vim.split(data.fargs[i], "ft:")[2]
                break
            end
            args[#args + 1] = data.fargs[i]
        end
        if #args == 0 then
            args = nil
        end
        RenderHTML(renderer, args, ft)
    else
        RenderHTML()
    end
end, {nargs = "*"})
