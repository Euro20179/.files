local function mkSnippet(cmdData)
    local snippetName = cmdData.args
    if snippetName == "" then
        snippetName = "<prefix>"
    end

    local snippetContents = {}
    if cmdData.range ~= 0 then
        snippetContents = vim.api.nvim_buf_get_lines(0, cmdData.line1 - 1, cmdData.line2, false)
    end

    local buf = vim.api.nvim_create_buf(false, false)

    local bufLines = vim.fn.extend({ snippetName }, snippetContents)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, bufLines)

    local ft = vim.bo.filetype
    vim.b[buf].ft = ft

    vim.bo[buf].buftype = "acwrite"


    vim.api.nvim_buf_set_name(buf, "Snippet maker [" .. ft .. "]")

    local termWidth = vim.o.columns
    local termHeight = vim.o.lines

    local winWidth = vim.fn.round(termWidth / 2)
    local winHeight = vim.fn.round(termHeight / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        col = termWidth - winWidth,
        row = 0,
        width = winWidth,
        height = winHeight,
        border = "single",
        footer = "q to close, :w<CR> to save"
    })

    vim.wo[win].statuscolumn =
    "%{v:lnum == 1 ? 'prefix ' : 'text ' . (&relativenumber ? (&number ? v:relnum == 0 ? v:lnum : v:relnum : v:relnum): v:lnum) }"

    if snippetName == "<prefix>" then
        --autoselect the <name> so the user can edit it
        vim.cmd.norm("gg0v$h" .. vim.api.nvim_replace_termcodes("<c-g>", true, false, true))
    end

    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            local name = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
            local text = vim.api.nvim_buf_get_lines(buf, 1, -1, false)

            local snippetsDir = vim.fn.stdpath("config") .. "/snippets/"

            if vim.fn.finddir(snippetsDir) == "" then
                vim.fn.mkdir(snippetsDir, "p")
            end

            local snippetsFile = snippetsDir .. vim.b[buf].ft .. ".json"

            if vim.fn.findfile(snippetsFile) == "" then
                local f = io.open(snippetsFile, "w")

                if f == nil then
                    vim.notify("Could not write snippets file", vim.log.levels.ERROR)
                    return
                end

                f:write("{}")
                f:close()
            end

            local f = io.open(snippetsFile, "r")

            if f == nil then
                vim.notify("Could not read snippets file", vim.log.levels.ERROR)
                return
            end

            local snippetsJsonText = f:read("a")
            local snippetsJson = vim.json.decode(snippetsJsonText)
            f:close()

            snippetsJson[name] = { prefix = name, body = text }

            f = io.open(snippetsFile, "w")

            if f == nil then
                vim.notify("Could not rewrite snippets file", vim.log.levels.ERROR)
                return
            end

            f:write(vim.json.encode(snippetsJson))
            f:close()

            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    })

    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end, {
        buffer = buf
    })
end

vim.api.nvim_create_user_command("Mksnippet", mkSnippet, {
    range = true,
    nargs = "?"
})
