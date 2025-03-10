vim.api.nvim_set_hl(0, "@markup.mmfml.highlight", {
    bg = "yellow",
    fg = "black"
})

---@param node TSNode
local function nodeToHTML(node)
    if node:child_count() > 0 then
        local html = ""
        for child in node:iter_children() do
            html = html .. nodeToHTML(child)
        end
        return html
    end

    local t = node:type()
    local gt = vim.treesitter.get_node_text

    if t == "line_break" then
        return "<br>"
    elseif t == "paragraph_separation" then
        return "<br><br>"
    elseif t == "word" then
        return "<span>" .. gt(node, 0, {}) .. "</span>"
    elseif t== "non_word" then
        return "<span>" .. gt(node, 0, {}) .. "</span>"
    elseif t == "divider" then
        return "<code>" .. gt(node, 0, {}) .. "</code>"
    elseif t == "space" then
        return "<code style='white-space: pre'>" .. gt(node, 0, {}) .. "</code>"
    elseif t == "footnote_start" then
        return "<sup>["
    elseif t == "footnote_name_text" or t == "footnote_block_name" then
        return gt(node, 0, {})
    elseif t == "footnote_end" then
        return "]</sup>"
    elseif t == "bold_start" then
        return "<strong>"
    elseif t == "bold_end" then
        return "</strong>"
    elseif t == "italic_start" then
        return "<i>"
    elseif t == "italic_end" then
        return "</i>"
    elseif t == "underline_start" then
        return "<u>"
    elseif t == "underline_end" then
        return "</u>"
    elseif t == "strikethrough_start" then
        return "<del>"
    elseif t == "strikethrough_end" then
        return "</del>"
    elseif t == "highlight_start" then
        return "<mark>"
    elseif t == "highlight_end" then
        return "</mark>"
    elseif t == "quote_start" then
        return "<blockquote>" .. gt(node, 0, {})
    elseif t == "quote_text" then
        return gt(node, 0, {})
    elseif t == "quote_end" then
        return gt(node, 0, {}) .. "</blockquote>"
    elseif t == "quote_author_indicator" then
        return "<cite>" .. gt(node, 0, {})
    elseif t == "quote_author" then
        return gt(node, 0, {}) .. "</cite>"
    elseif t == "pre_sample_start" then
        return "<code style='white-space: pre'>"
    elseif t == "pre_sample_text" then
        return gt(node, 0, {})
    elseif t == "pre_sample_end" then
        return "</code>"
    elseif t == "header" then
        local fullHT = gt(node, 0, {})

        local spaceIdx = vim.fn.stridx(fullHT, ' ')

        local eqCount = vim.fn.count(vim.fn.slice(fullHT, 0, spaceIdx), "=")

        local ht = vim.fn.trim(fullHT, " =")

        local headerLevel = vim.fn.min({eqCount, 6})

        return "<h" .. tostring(headerLevel) .. ">" .. ht .. "</h" .. tostring(headerLevel) .. ">"
    elseif t == "link_url" then
        local text = gt(node, 0, {})
        return "<a href=\"" .. vim.fn.trim(text, " ") .. '">' .. text .. "</a>"
    elseif t== "list" then
        local text = gt(node, 0, {})
        local firstChar, _ = text:find('[^%s]')
        local whiteSpace = vim.fn.slice(text, 0, firstChar - 1)
        return "<br>" .. "<code style='white-space: pre'>" .. whiteSpace .. "</code>" .. gt(node, 0, {})
    elseif t == "code_block_start" then
        return "<pre>"
    elseif t == "code_block_end" then
        return "</pre>"
    elseif t == "code_text" then
        return gt(node, 0, {})
    elseif t == "language" then
        return "<code>&gt;" .. gt(node, 0, {}) .. "</code><br>"
    elseif t == "inline_code_start" then
        local language = vim.fn.trim(gt(node, 0, {}), "$")
        return "<code style='white-space: pre'><span>" .. language .. ":</span>"
    elseif t == "code" then
        return gt(node, 0, {})
    elseif t == "inline_code_end" then
        return "</code>"
    end
    return ""
end

local function toHTML()
    local parser = vim.treesitter.get_parser(0, "mmfml")

    if parser == nil then
        return
    end

    local langTree = parser:parse()

    local html = "<head><meta charset=\"utf-8\"></head>"
    for _, tree in pairs(langTree) do
        local root = tree:root()
        html = html .. nodeToHTML(root)
    end

    local out = vim.fn.tempname() .. ".html"
    local f = io.open(out, "w")

    if f == nil then
        return
    end

    f:write(html)
    f:close()
    vim.cmd.execute('"vsplit " .. "' .. out .. '"')

    vim.fs.rm(out)
end

vim.api.nvim_create_user_command("ExportHTML", toHTML, {})

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
    local links = vim.iter(getLinks()):flatten(100):map(function(linknode)
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
    end):totable()

    vim.fn.setloclist(0, links)
    vim.cmd.lwin()
end, {})

vim.keymap.set("n", "<a-l>", ":Links<CR>", {
    buffer = 0
})

-- vim.keymap.set("n", "gf", function()
--     --make it so that if the file doesn't exist, it edits anyway
--     vim.cmd.edit("<cfile>")
-- end)

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
vim.opt_local.conceallevel = 1

vim.b.link_search = [=[|\zs.\ze[^)]*|]=]

vim.b.mmfml_textwidth = vim.bo.textwidth
