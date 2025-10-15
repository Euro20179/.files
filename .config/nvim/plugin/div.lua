local function centerPad(text, size)
    if #text >= size then
        return text
    end

    local needed = size - #text
    local left = vim.fn.floor(needed / 2)
    local right = vim.fn.ceil(needed / 2)

    local final = ""
    for _ = 1, left do
        final = final .. ' '
    end

    final = final .. text

    for _ = 1, right do
        final = final .. ' '
    end

    return final
end

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

vim.api.nvim_create_user_command("Boxify", function(args)
    if args.range ~= 2 then
        vim.notify("A visual range must be selected", vim.log.levels.ERROR)
        return
    end

    local sl = vim.fn.line("'<") - 1
    local sc = vim.fn.col("'<") - 1
    local el = vim.fn.line("'>") - 1
    local ec = vim.fn.col("'>")

    local text = vim.api.nvim_buf_get_text(0, sl, sc, el, ec, {})

    local lineCount = #text
    local longestLineLen = #text[1]
    for _, line in ipairs(text) do
        if #line > longestLineLen then
            longestLineLen = #line
        end
    end

    local tl = "┌"
    local tr = "┐"
    local br = "┘"
    local bl = "└"
    local h = "─"
    local v = "│"

    local chars = args.fargs

    if chars[1] == "b" then
        tl = "┏"
        tr = "┓"
        bl = "┗"
        br = "┛"
        h = "━"
        v = "┃"
    elseif chars[1] == "d" then
        tr = "╗"
        tl = "╔"
        br = "╝"
        bl = "╚"
        h = "═"
        v = "║"
    else
        for _, char in pairs(chars) do
            if vim.startswith(char, "h=") then
                h = string.sub(char, 3)
            elseif vim.startswith(char, "v=") then
                v = string.sub(char, 3)
            elseif vim.startswith(char, "tl=") then
                v = string.sub(char, 4)
            elseif vim.startswith(char, "tr=") then
                v = string.sub(char, 4)
            elseif vim.startswith(char, "br=") then
                v = string.sub(char, 4)
            elseif vim.startswith(char, "bl=") then
                v = string.sub(char, 4)
            end
        end
    end

    local newText = {}

    -- top line {{{
    newText[1] = tl
    for i = 1, longestLineLen do
        newText[1] = newText[1] .. h
    end
    newText[1] = newText[1] .. tr
    -- }}}

    -- middle text {{{
    for _, line in ipairs(text) do
        line = v .. centerPad(line, longestLineLen) .. v
        newText[#newText + 1] = line
    end
    -- }}}

    -- bottom line {{{
    local last = #newText + 1
    newText[last] = bl
    for i = 1, longestLineLen do
        newText[last] = newText[last] .. h
    end
    newText[last] = newText[last] .. br
    -- }}}

    vim.api.nvim_buf_set_text(0, sl, sc, el, ec - 1, newText)
end, { range = true, nargs = "?" })

vim.api.nvim_create_user_command("Divline", function(cmdData)
    local endCol = getScreenWidth()

    local charCount = endCol - 1
    if #cmdData.fargs == 2 then
        charCount = tonumber(cmdData.fargs[2]) or endCol - 1
    end

    local line = vim.fn.line(".")
    if cmdData.line1 > 0 then
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
end, { addr = "lines", bang = true, nargs = "*" })

vim.api.nvim_create_user_command("Divword", function(cmdData)
    local endCol = getScreenWidth()

    local charCount = endCol
    if #cmdData.fargs > 2 then
        charCount = tonumber(cmdData.fargs[3]) or endCol
    end

    charCount = charCount - 1

    local line = vim.fn.line(".")
    if cmdData.line1 > 0 then
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
end, { addr = 'lines', bang = true, nargs = "*" })
