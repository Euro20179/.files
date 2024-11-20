vim.api.nvim_set_hl(0, "@markup.mmfml.highlight", {
    bg = "yellow",
    fg = "black"
})

---@param node TSNode
---@return TSNode[]
local function findLinksInNode(node)
    if node == nil then
        return {}
    end
    if node:type() == "link_url" then
        return { node }
    end
    return vim.iter(node:iter_children()):map(function(child)
        local childLinks = findLinksInNode(child)
        return vim.iter(childLinks):flatten(1):totable()[1]
    end):totable()
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
    end):totable()[1]
    -- ---@param child TSNode
    -- vim.iter(t:children()):map(function(child)
    --     local childLinks = findLinksInNode(child)
    --     vim.list_extend(links, childLinks)
    -- end)
    -- return links
end

---@param node TSNode
---@return TSNode[]
local function findAnchorsInNode(node)
    if node == nil then
        return {}
    end
    if node:type() == "anchor" then
        return { node }
    end
    return vim.iter(node:iter_children()):map(function(child)
        local childAnchors = findAnchorsInNode(child)
        return vim.iter(childAnchors):flatten(1):totable()[1]
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
    end):totable()[1]
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
    local anchorNodes = getAnchors()
    local links = vim.fn.flatten(vim.iter(anchorNodes):map(function(node)
        local text = getRangeOfNode(node)
        if text == pattern or text == "#" .. pattern .. "#" then
            local searchPattern = pattern
            return {
                name = text,
                filename = info.buf_ffname,
                cmd = '/' .. searchPattern
            }
        end
        return {}
    end):totable())
    return links
end

local function insert_complete_tagfunc(pattern, info)
    local patternreg = vim.regex(pattern)
    return vim.fn.flatten(vim.iter(getLinks()):map(function(node)
        local text = getRangeOfNode(node)
        local start, end_ = patternreg:match_str(text)
        if start ~= nil then
            return {
                name = text,
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
    vim.fn.setloclist(0, vim.iter(getLinks()):map(function(linknode)
        local row, col, erow, ecol = linknode:range()
        if row == nil or col == nil or erow == nil or ecol == nil then
            vim.print(row, col, erow, ecol)
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

vim.opt_local.tagfunc = 'v:lua.Tagfunc'
vim.opt_local.iskeyword = "!-~,^*,^|,^\",192-255"

vim.b.link_search = [=[\[[^\]]\+\]|\zs.\ze[^)]*|]=]
