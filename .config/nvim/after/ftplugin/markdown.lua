vim.bo.equalprg = "prettier --parser markdown"

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

---@param rowCount? integer
function InsertRow(rowCount)
    rowCount = rowCount or 1
    local nodes = FindChildrenNearCursor({
        pipe_table = {
            child_name = "pipe_table_[rowhead]+" --matches only pipe_table_(row|head) best code 👍
        }
    })

    local cursorRow = nodes.currentNode
    local count = 0
    for child in cursorRow:iter_children() do
        if child:type() ~= "pipe_table_cell" then
            goto continue
        end
        count = count + 1
        ::continue::
    end

    for _ = 0, rowCount - 1, 1 do
        local rowText = string.rep("| ", count)
        vim.fn.append(vim.fn.line("."), rowText .. "|")
    end
end

vim.keymap.set("i", "<a-r>", function ()
    InsertRow()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { pos[1] + 1, 1 })
end, { desc = "[MARKDOWN-TABLE]: Add row below" })

vim.api.nvim_create_user_command("MRow", function(data)
    InsertRow(tonumber(data.args) or 1)
end, { nargs = "?" })

vim.keymap.set("i", "<c-.>", function()
    JumpToNearNodes(1, {
        pipe_table = {
            child_name = "pipe_table_cell"
        }
    })
end, { desc = "[MARKDOWN-TABLE]: Jump to next cell" })

--use the new signature for JumpChild (parentChildRelations)
vim.keymap.set("i", "<c-s-.>", function()
    JumpToNearNodes(-1, {
        pipe_table = {
            child_name = "pipe_table_cell"
        }
    })
end, { desc = "[MARKDOWN-TABLE]: Jump to previous cell" })

vim.api.nvim_buf_create_user_command(0, "Links", function()
    vim.fn.setqflist(MarkdownGetLinks())
    vim.cmd.cwin()
end, {})

vim.keymap.set("n", "<a-l>", ":Links<CR>", {
    buffer = 0
})
