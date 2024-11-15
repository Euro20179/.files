local tohtml = require "tohtml"

local function sswebsite(url)
    local browser = vim.env["BROWSER"] or "firefox"
    vim.system({ browser, '--new-instance', "--screenshot", url })
end

function Ssrange(line1, line2)
    local tmpFile = vim.fn.tempname()

    local html = tohtml.tohtml(0, {
        range = { line1, line2 }
    })

    vim.fn.writefile(html, tmpFile)

    sswebsite("file://" .. tmpFile)
end

function Ssbuffer(bufNo)
    local curBuf = vim.api.nvim_win_get_buf(0)
    vim.api.nvim_win_set_buf(0, bufNo)
    local html = tohtml.tohtml(0)

    local tmpFile = vim.fn.tempname()

    vim.fn.writefile(html, tmpFile)

    sswebsite("file://" .. tmpFile)

    vim.api.nvim_win_set_buf(0, curBuf)
end

function Ssfile(file)
    if file == "" then
        return
    end

    local bufnr = vim.api.nvim_create_buf(true, false)

    local ok = pcall(vim.api.nvim_buf_set_name, bufnr, file)
    if not ok then
        local existingBufnr = vim.iter(vim.api.nvim_list_bufs())
            :find(function(buf)
                --bufname() returns the bufname as listed by :ls
                --nvim_buf_get_name returns the full path for the bufname
                --we ned to check both because nvim_buf_set_name errors on both
                return vim.fn.bufname(buf) == file or vim.api.nvim_buf_get_name(buf) == file
            end)
        Ssbuffer(existingBufnr)
        -- Ssbuffer(
        return
    end

    vim.fn.bufload(bufnr)

    local win = vim.api.nvim_open_win(bufnr, false, {
        split = "left"
    })

    local tmpFile = vim.fn.tempname()
    local html = tohtml.tohtml(win)
    vim.fn.writefile(html, tmpFile)

    sswebsite("file://" .. tmpFile)
    vim.api.nvim_buf_delete(bufnr, {
        force = true
    })
end

vim.api.nvim_create_user_command("Ssfile", function(data)
    local file = data.args
    --range, no file
    if data.count >= 0 then
        Ssrange(data.line1, data.line2)
        --no range, no file
    elseif file == "" then
        Ssbuffer(0)
        --no range, file
    else
        Ssfile(file)
    end
end, { complete = "file", nargs = "?", range = true })
