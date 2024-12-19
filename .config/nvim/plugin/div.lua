
local function falsey(val)
    if val == 0 or val == "" or val == nil then
        return true
    end
    return false
end

local function getScreenWidth()
    local width = vim.b.mmfml_textwidth
    if falsey(width) then
        width = vim.bo.textwidth
    end
    if falsey(width) then
        width = 80
    end
    return width
end

vim.api.nvim_create_user_command("Divline", function(cmdData)
    local endCol = getScreenWidth()

    local charCount = endCol - 1
    if #cmdData.fargs == 2 then
        charCount = tonumber(cmdData.fargs[2]) or endCol - 1
    end

    local line = vim.fn.line(".")
    if cmdData.range > 0 then
        line = cmdData.line1
    end

    local lineText = vim.fn.getline(line)
    if not cmdData.bang and lineText ~= "" then
        vim.notify(string.format("line %d is not empty, use ! to replace", line))
        return
    end

    local char = "-"
    if #cmdData.fargs > 0 then
        char = cmdData.fargs[1]
    end

    vim.fn.setline(line, string.rep(char, charCount))
end, { range = true, bang = true, nargs = "*" })

vim.api.nvim_create_user_command("Divword", function(cmdData)
    local endCol = getScreenWidth()

    local charCount = endCol
    if #cmdData.fargs > 2 then
        charCount = tonumber(cmdData.fargs[3]) or endCol
    end

    charCount = charCount - 1

    local line = vim.fn.line(".")
    if cmdData.range > 0 then
        line = cmdData.line1
    end

    local lineText = vim.fn.getline(line)
    if not cmdData.bang and lineText ~= "" then
        vim.notify(string.format("line %d is not empty, use ! to replace", line))
        return
    end

    if #cmdData.fargs > 1 then
        lineText = cmdData.fargs[2]
    end

    local char = "-"
    if #cmdData.fargs > 0 then
        char = cmdData.fargs[1]
    end

    local remainingLen = charCount - #lineText

    local left = remainingLen / 2
    local right = remainingLen - left

    -- if the len of text is even, it's off by one for some reason
    if #lineText % 2 == 0 then
        right = right + 1
    end

    local finalText = string.format(
        "%s%s%s",
        string.rep(char, left),
        lineText,
        string.rep(char, right)
    )

    vim.fn.setline(line, finalText)
end, { range = true, bang = true, nargs = "*" })
