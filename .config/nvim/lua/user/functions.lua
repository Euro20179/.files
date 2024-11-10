
function Rword()
    local words = {}
    for line in io.lines("/home/euro/Documents/words.txt") do
        words[#words + 1] = line
    end
    return words[math.random(1, #words)]
end

function EditSheet()
    local file = vim.api.nvim_buf_get_name(0)
    GotoTerminalBuf()
    vim.cmd.sleep("500ms")
    vim.api.nvim_feedkeys('i' .. "sheet " .. file .. "\n", "n", false)
end

function PreviewFile()
    local filename = vim.api.nvim_buf_get_name(0)
    local out = vim.fn.tempname()
    local command = ({
        asciidoc = { "asciidoc", "-o", out, filename },
        markdown = { "pandoc", "-fgfm", "-thtml", "-o", out, filename }
    })[vim.bo.filetype]

    if command == nil then
        vim.print(vim.bo.filetype .. " Does not have a preview command")
        return
    end

    vim.system(command):wait()

    local browser = vim.fn.getenv("BROWSER_SCRIPTING") or vim.fn.getenv("BROWSER") or "firefox"
    vim.cmd.echo('"' .. out .. '"')
    vim.system({ browser, out })
end

function Diff_since_tag()
    vim.ui.input({ prompt = "Tag: " }, function(text)
        vim.cmd([[read !git diff ]] .. text)
    end)
end

function Fmt_date()
    vim.ui.input({ prompt = "Date Fmt: " }, function(text)
        local date_line = vim.fn.line(".")
        local date_col = vim.fn.col(".")
        local date = "" .. os.date(text)
        vim.api.nvim_buf_set_text(0, date_line - 1, date_col - 1, date_line - 1, date_col - 1, { date })
    end)
end

function Word_count()
    vim.api.nvim_cmd({
        addr = "line",
        args = { "detex", "%", "|", "wc", "-w" },
        cmd = "!",
        magic = {
            bar = false,
            file = true
        }
    }, {})
end

function Winbar()
    local text = " "
    text = text .. require 'nvim-navic'.get_location()
    return text
end

function ChatBotComment(data)
    OllamaDocument(data)
end

-- function ChatBotDocument(data)
--     _chatbotmain(data, "Add documentation")
-- end

function GotoTerminalBuf()
    local harpoon = require "harpoon"
    for _, tid in ipairs(vim.api.nvim_list_tabpages()) do
        for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(tid)) do
            local bid = vim.api.nvim_win_get_buf(wid)
            local name = vim.api.nvim_buf_get_name(bid)
            if vim.startswith(name, "term://") then
                vim.api.nvim_set_current_tabpage(tid)
                vim.api.nvim_tabpage_set_win(tid, wid)
                return
            end
        end
    end
    -- if no term buf found
    harpoon:list():append()
    vim.cmd.terminal()
end

function GetLspNames()
    local names = vim.iter(vim.lsp.get_clients()):map(function(c) return c.name end):join(" ")

    if names ~= "" then
        return vim.trim("" .. names)
    end

    return ""
end

---@param parentNode TSNode
---@param childName string
local function getCorrectChildren(parentNode, childName)
    ---@type table<TSNode>
    local correctChildren = {}
    for child in parentNode:iter_children() do
        if child:type():match(childName) then
            correctChildren[#correctChildren + 1] = child
        end
        for _, c in ipairs(getCorrectChildren(child, childName)) do
            correctChildren[#correctChildren + 1] = c
        end
    end
    return correctChildren
end

---@class NodeRelation
---@field child_name string

---@alias NodeName string

---@alias NodeRelationList table<NodeName, NodeRelation>

---@class CursorNodeRelations
---@field currentNode TSNode
---@field before table<TSNode>
---@field after table<TSNode>

---@param parentChildRelations NodeRelationList
---@return CursorNodeRelations
function FindChildrenNearCursor(parentChildRelations)
    local node = vim.treesitter.get_node {}
    local cpos = vim.api.nvim_win_get_cursor(0)

    if node == nil then
        vim.notify("No ts node under cursor", vim.log.levels.ERROR)
        return {}
    end

    ---@type table<string>
    local possibleParents = vim.tbl_keys(parentChildRelations)

    --finds the parent of where the cursor is
    while node ~= nil and node:parent() and vim.fn.index(possibleParents, node:type()) == -1 do
        node = node:parent()
    end

    if node == nil or vim.fn.index(possibleParents, node:type()) == -1 then
        vim.notify(string.format("Could not find root: %s", possibleParents[1]), vim.log.levels.ERROR)
        return {}
    end

    local children = getCorrectChildren(node, parentChildRelations[node:type()].child_name)

    local cursorNodeIndex, _ = vim.iter(children)
        :enumerate()
        :find(function(_, n)
            --the first child that the cursor is within is the child we want
            --(probably)
            --this is because this list of children is only the list that the user wants to jump between
            --therefore there should not be extranious children unless the user puts a bad regex
            --
            --matching exactly by which node id the cursor is on often doesnt work
            --because sometimes there's a group node with children nodes,
            --and the user wants to select the group node,
            --but the cursor will be on one of the children nodes
            --eg:
            --(string (st<cursor>ring_begin) (string_content) (string_end)),
            --but the user wants to select the (string) node
            --(string) will be the first matched child,
            --because the tree is in order
            return vim.treesitter.is_in_node_range(n, cpos[1] - 1, cpos[2])
        end)

    if cursorNodeIndex == nil then
        vim.notify(string.format("Cursor not in a child of %s", node:type()), vim.log.levels.ERROR)
        return {}
    end

    return {
        currentNode = children[cursorNodeIndex],
        before = vim.iter(vim.list_slice(children, 0, cursorNodeIndex - 1)):rev():totable(),
        after = vim.list_slice(children, cursorNodeIndex + 1)
    }
end

---@param node TSNode
function JumpToNode(node)
    local nsr, nsc = vim.treesitter.get_node_range(node)
    vim.api.nvim_win_set_cursor(0, { nsr + 1, nsc })
end

---Jumps to the +-nth child node near the cursor relative to a parent
---@param jumpCount number
---@param parentChildRelations NodeRelationList
function JumpToNearNodes(jumpCount, parentChildRelations)
    if jumpCount == 0 then
        return
    end
    local nearChildren = FindChildrenNearCursor(parentChildRelations)

    if nearChildren == nil then
        return
    end

    local tblToUse
    if jumpCount > 0 then
        tblToUse = nearChildren.after
    else
        tblToUse = nearChildren.before
    end

    jumpCount = vim.fn.abs(jumpCount)

    if tblToUse == nil or tblToUse[jumpCount] == nil then
        return
    end

    JumpToNode(tblToUse[jumpCount])
end

vim.api.nvim_create_user_command("EditSheet", EditSheet, {})
vim.api.nvim_create_user_command("Preview", PreviewFile, {})
-- vim.api.nvim_create_user_command("ChatBotDocument", ChatBotDocument, { range = true })
vim.api.nvim_create_user_command("ChatBotComment", ChatBotComment, { range = true })
-- vim.api.nvim_create_user_command("ChatBotQuery", queryChatBot, {})
--
