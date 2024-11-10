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

