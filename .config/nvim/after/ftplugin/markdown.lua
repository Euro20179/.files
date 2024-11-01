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


vim.keymap.set("i", "<c-.>", function()
    JumpChild({
        pipe_table = {
            child_name = "pipe_table_cell",
            jump_count = 1
        }
    })
end)

--use the new signature for JumpChild (parentChildRelations)
vim.keymap.set("i", "<c-s-.>", function()
    JumpChild({
        pipe_table = {
            child_name = "pipe_table_cell",
            jump_count = -1
        }
    })
end)

vim.api.nvim_buf_create_user_command(0, "Links", function()
    vim.fn.setqflist(MarkdownGetLinks())
    vim.cmd.cwin()
end, {})

vim.keymap.set("n", "<a-l>", ":Links<CR>", {
    buffer = 0
})
