vim.api.nvim_set_hl(0, "@markup.mmfml.highlight", {
    bg = "yellow",
    fg = "black"
})

---@param node TSNode
---@param type string
---@return TSNode[]
local function findNodeTypeInNode(node, type)
    if node == nil then
        return {}
    end
    if node:type() == type then
        return { node }
    end
    return vim.iter(node:iter_children()):map(function(child)
        local childLinks = findNodeTypeInNode(child, type)
        return childLinks
    end):totable()
end

---@param node TSNode
---@return TSNode[]
local function findLinksInNode(node)
    return findNodeTypeInNode(node, "link_url")
end

---@return TSNode[]
local function getLinks()
    local parser = vim.treesitter.get_parser(0, "mmfml", {})
    if parser == nil then
        return {}
    end

    local tree = parser:parse()
    ---@param node TSTree
    return vim.iter(tree):map(function(node)
        return findLinksInNode(node:root())
    end):totable()
end

---@param node TSNode
---@return TSNode[]
local function findAnchorsInNode(node)
    return findNodeTypeInNode(node, "anchor")
end

local function getHeaders()
    local parser = vim.treesitter.get_parser(0, "mmfml", {})
    if parser == nil then
        return {}
    end

    local tree = parser:parse()
    ---@param node TSTree
    return vim.iter(tree):map(function(node)
        return findNodeTypeInNode(node:root(), "header")
    end):totable()
end

local function getAnchors()
    local parser = vim.treesitter.get_parser(0, "mmfml", {})
    if parser == nil then
        return {}
    end

    local tree = parser:parse()
    ---@param node TSTree
    return vim.iter(tree):map(function(node)
        return findAnchorsInNode(node:root())
    end):totable()
end

local function getFootnoteBlocks()
    local parser = vim.treesitter.get_parser(0, "mmfml", {})
    if parser == nil then
        return {}
    end

    local tree = parser:parse()

    return vim.iter(tree):map(function(node)
        return findNodeTypeInNode(node:root(), "footnote_block_name")
    end):totable()
end

local function getRangeOfNode(node)
    local row, col, erow, ecol = node:range()
    if row == nil or col == nil or erow == nil or ecol == nil then
        vim.print(row, col, erow, ecol)
        vim.notify("A disaster has happened, the range for the linknode is undefined")
        return
    end
    return vim.api.nvim_buf_get_text(0, row, col, erow, ecol, {})[1]
end

local function normalmode_tagfunc(pattern, info)
    local anchorNodes = vim.iter(getAnchors()):flatten(100):totable()
    local footnoteNodes = vim.iter(getFootnoteBlocks()):flatten(100):totable()
    local headerNodes = vim.iter(getHeaders()):flatten(100):totable()

    local headers = vim.fn.flatten(vim.iter(headerNodes):map(function(node)
        local text = getRangeOfNode(node)

        if text == nil then
            return {}
        end

        if text:match(".*=+%s*" .. pattern) then
            return {
                name = text,
                filename = info.buf_ffname,
                cmd = '/' .. text
            }
        end
        return {}
    end):totable())

    local anchorLinks = vim.fn.flatten(vim.iter(anchorNodes):map(function(node)
        local text = getRangeOfNode(node)
        if text == pattern or text == "#" .. pattern .. "#" then
            local searchPattern = '#' .. pattern .. '#'
            return {
                name = text,
                filename = info.buf_ffname,
                cmd = '/' .. searchPattern
            }
        end
        return {}
    end):totable())

    local footnotes = vim.fn.flatten(vim.iter(footnoteNodes):map(function(node)
        local text = getRangeOfNode(node)
        if text == pattern or text == '^[' .. pattern .. ']' then
            --vim regex is CRAZY,
            --an optional end of line in the middle of the regex is crazy
            local pos = vim.fn.searchpos([[^\^\[]] .. text .. [[\]:\s*\(\_$\n\)\?\s*\zs.]],
                "n")
            return {
                name = text,
                filename = info.buf_ffname,
                cmd = '/\\%' .. tostring(pos[1]) .. 'l' .. '\\%' .. tostring(pos[2]) .. 'c'
            }
        end
        return {}
    end):totable())

    local all = {}
    all = vim.list_extend(all, anchorLinks)
    all = vim.list_extend(all, footnotes)
    all = vim.list_extend(all, headers)

    return all
end

local function insert_complete_tagfunc(pattern, info)
    local patternreg = vim.regex(pattern)

    local allTags = vim.iter(getLinks()):flatten(100):totable()
    allTags = vim.list_extend(allTags, vim.iter(getAnchors()):flatten(100):totable())
    allTags = vim.list_extend(allTags, vim.iter(getFootnoteBlocks()):flatten(100):totable())
    allTags = vim.list_extend(allTags, vim.iter(getHeaders()):flatten(100):totable())

    return vim.fn.flatten(vim.iter(allTags):map(function(node)
        local text = getRangeOfNode(node)

        if text == nil then
            return {}
        end

        local start, end_ = patternreg:match_str(text)
        if start ~= nil then
            return {
                name = vim.fn.trim(text, "=|#[] "),
                filename = vim.fn.expand("%"),
                cmd = '/|' .. text .. '|'
            }
        else
            return {}
        end
    end):totable())
end

---@param flags string
function Tagfunc(pattern, flags, info)
    if flags:match("i") then
        return insert_complete_tagfunc(pattern, info)
    elseif flags == "c" then
        return normalmode_tagfunc(pattern, info)
    end
    return {}
end

vim.api.nvim_create_user_command("Links", function()
    ---@param linknode TSNode
    vim.fn.setloclist(0, vim.iter(getLinks()):flatten(100):map(function(linknode)
        local row, col, erow, ecol = linknode:range()
        if row == nil or col == nil or erow == nil or ecol == nil then
            vim.notify("A disaster has happened, the range for the linknode is undefined")
            return
        end
        local text = vim.api.nvim_buf_get_text(0, row, col, erow, ecol, {})[1]
        return {
            bufnr = 0,
            filename = vim.fn.expand("%"),
            col = col + 1,
            lnum = row + 1,
            end_col = ecol + 1,
            end_lnum = erow + 1,
            text = text
        }
    end):totable())
    vim.cmd.lwin()
end, {})

vim.keymap.set("n", "<a-l>", ":Links<CR>", {
    buffer = 0
})

vim.keymap.set("n", "gf", function()
    --make it so that if the file doesn't exist, it edits anyway
    vim.cmd.edit("<cfile>")
end)

vim.keymap.set('n', "[h", function()
    local cursorPos = vim.fn.getpos('.')

    vim.cmd.mark "'"

    ---@param node TSNode
    local headers = vim.iter(getHeaders()):flatten(100):filter(function(node)
        local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
        if cursorPos[2] - 1 > srow then
            return true
        end
        return false
    end):totable()
    table.sort(headers, function(node, node2)
        local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
        local srow2, _, _, _ = vim.treesitter.get_node_range(node2)
        if srow < srow2 then
            return false
        else
            return true
        end
    end)

    if #headers < 1 then
        return
    end

    local srow, scol, errow, ecol = headers[1]:range()
    vim.fn.setpos('.', { 0, srow + 1, scol, 0 })
end, { remap = true })

vim.keymap.set('n', "]h", function()
    local cursorPos = vim.fn.getpos('.')

    vim.cmd.mark "'"

    ---@param node TSNode
    local headers = vim.iter(getHeaders()):flatten(100):filter(function(node)
        local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
        if cursorPos[2] - 1 < srow then
            return true
        end
        return false
    end):totable()
    table.sort(headers, function(node, node2)
        local srow, scol, erow, ecol = vim.treesitter.get_node_range(node)
        local srow2, _, _, _ = vim.treesitter.get_node_range(node2)
        if srow > srow2 then
            return false
        else
            return true
        end
    end)

    if #headers < 1 then
        return
    end

    local srow, scol, errow, ecol = headers[1]:range()
    vim.fn.setpos('.', { 0, srow + 1, scol, 0 })
end, { remap = true })

vim.api.nvim_create_user_command("Divline", function(cmdData)
    local endCol = vim.b.mmfml_textwidth or 80

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
    local endCol = vim.b.mmfml_textwidth or 80

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

vim.keymap.set("n", "gO", function()
    ---@type TSNode[]
    local headers = vim.iter(getHeaders()):flatten(100):totable()
    ---@type TSNode[]
    local anchors = vim.iter(getAnchors()):flatten(100):totable()

    local bufNr = vim.api.nvim_win_get_buf(0)
    local bufName = vim.fn.expand("%:t")

    local list = {}
    for _, anchor in pairs(anchors) do
        local sr, sc, er, ec = anchor:range(false)
        list[#list + 1] = {
            bufnr = bufNr,
            filename = bufName,
            lnum = sr + 1,
            col = sc,
            end_lnum = er + 1,
            end_col = ec,
            text = vim.treesitter.get_node_text(anchor, bufNr, {})
        }
    end

    for _, anchor in pairs(headers) do
        local sr, sc, er, ec = anchor:range(false)
        list[#list + 1] = {
            bufnr = bufNr,
            filename = bufName,
            lnum = sr + 1,
            col = sc,
            end_lnum = er + 1,
            end_col = ec,
            text = vim.treesitter.get_node_text(anchor, bufNr, {})
        }
    end

    vim.fn.setloclist(0, list)
    vim.cmd.lwin()
end, { buffer = true })

vim.opt_local.tagfunc = 'v:lua.Tagfunc'
vim.opt_local.iskeyword = "!-~,^[,^],^*,^|,^\",192-255"

vim.b.link_search = [=[|\zs.\ze[^)]*|]=]

vim.b.mmfml_textwidth = vim.wo.colorcolumn
