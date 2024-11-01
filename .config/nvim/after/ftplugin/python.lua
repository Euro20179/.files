vim.keymap.set("i", "<c-.>", function()
    JumpToNearNodes(1, {
        parameters = {
            child_name = "identifier",
        },
        list = {
            child_name = "^[a-z]*$",
        }
    })
end)

vim.keymap.set("i", "<c-s-.>", function()
    JumpToNearNodes(-1, {
        parameters = {
            child_name = "identifier",
        },
        list = {
            child_name = "^[a-z]*$",
        }
    })
end)
