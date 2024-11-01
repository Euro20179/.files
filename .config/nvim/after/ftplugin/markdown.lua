vim.bo.equalprg = "prettier --parser markdown"

-- vim.api.nvim_set_keymap("n", "<Leader>tf", ':lua require("tablemd").format()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tc", ':lua require("tablemd").insertColumn(false)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>td", ':lua require("tablemd").deleteColumn()<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tr", ':lua require("tablemd").insertRow(false)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tR", ':lua require("tablemd").insertRow(true)<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tj", ':lua require("tablemd").alignColumn("left")<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tk", ':lua require("tablemd").alignColumn("center")<cr>', { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>tl", ':lua require("tablemd").alignColumn("right")<cr>', { noremap = true })

function MarkdownGetLinks()
    local re = vim.regex("\\(\\[.*\\]\\)\\@<=([^[:space:]]*)")
    local links = {}
    local bufnr = vim.api.nvim_get_current_buf()

    for i = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do
        local line = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]

        local s, e = re:match_str(line)

        local offset = 0

        while s ~= nil and e ~= nil do
            local linkText = vim.fn.slice(line, s + 1, e - 1)
            line = vim.fn.slice(line, 0, s) .. vim.fn.slice(line, e)
            links[#links + 1] = {
                bufnr = bufnr,
                lnum = i + 1,
                pattern = linkText,
                col = s + 2 + offset,
                text = linkText
            }
            offset = offset + (e - s)
            s, e = re:match_str(line)
        end
    end
    return links
end

function JumpCell(jumpCount)
    if jumpCount == 0 then
        vim.notify("jumpCount cannot be 0", vim.log.levels.ERROR)
        return
    end

    local node = vim.treesitter.get_node {}

    if node == nil then
        vim.notify("No ts node under cursor", vim.log.levels.ERROR)
        return
    end

    local cursorNodeId = node:id()

    --finds the root of the table
    while node ~= nil and node:parent() and node:type() ~= "pipe_table" do
        node = node:parent()
    end

    if node == nil then
        vim.notify("Could not find table root", vim.log.levels.ERROR)
        return
    end

    local tblChildren = vim.iter(node:iter_children())

    ---@type table<TSNode>
    local tblRows = tblChildren:filter(function(n)
        return n:type() == "pipe_table_row" or n:type() == "pipe_table_header"
    end):totable()

    tblRows = vim.iter(tblRows):flatten():totable()

    --gets all cells from all rows and flattens into a list
    ---@type table<TSNode>
    local tblCells = vim.iter(tblRows)
        :filter(function(n) return n ~= nil end)
        :map(function(n)
            local cells = vim.iter(n:iter_children()):filter(function(rowChild)
                return rowChild:type() == "pipe_table_cell"
            end):totable()

            return cells
        end)
        :flatten(2)
        :totable()

    local cursorNodeIndex, _ = vim.iter(tblCells)
        :map(function(n) return n:id() end)
        :enumerate()
        :find(function(_, id)
            return id == cursorNodeId
        end)

    if cursorNodeIndex == nil then
        vim.notify("Cursor not in table", vim.log.levels.ERROR)
        return
    end

    local nextCell
    if jumpCount > 0 then
        nextCell = tblCells[cursorNodeIndex + jumpCount]
    else
        --take the first cnIdx nodes, reverse it, then grab the item
        --reverse it, that way index 1, is the first cell before the cursor
        nextCell = vim.iter(tblCells):take(cursorNodeIndex - 1):rev():nth(vim.fn.abs(jumpCount))
    end

    if nextCell == nil then
        return
    end

    local nsr, nsc, _, _ = vim.treesitter.get_node_range(nextCell)
    vim.api.nvim_win_set_cursor(0, { nsr + 1, nsc })
end

vim.keymap.set("i", "<c-.>", function()
    JumpCell(1)
end)

vim.keymap.set("i", "<c-s-.>", function()
    JumpCell(-1)
end)

vim.api.nvim_buf_create_user_command(0, "Links", function()
    vim.fn.setqflist(MarkdownGetLinks())
    vim.cmd.cwin()
end, {})

vim.keymap.set("n", "<a-l>", ":Links<CR>", {
    buffer = 0
})
