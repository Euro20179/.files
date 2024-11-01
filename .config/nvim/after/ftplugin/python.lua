vim.keymap.set("i", "<c-.>", function()
    local nearChildren = FindChildrenNearCursor({
        parameters = {
            child_name = "identifier",
        },
        list = {
            child_name = "^[a-z]*$",
        }
    })

    if nearChildren.after == nil or nearChildren.after[1] == nil then
        return
    end

    JumpToNode(nearChildren.after[1])
end)

vim.keymap.set("i", "<c-s-.>", function()
    local nearChildren = FindChildrenNearCursor({
        parameters = {
            child_name = "identifier",
        },
        list = {
            child_name = "^[a-z]*$",
        }
    })

    if nearChildren.before == nil or nearChildren.before[1] == nil then
        return
    end

    JumpToNode(nearChildren.before[1])
end)
