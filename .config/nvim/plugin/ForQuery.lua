vim.api.nvim_create_user_command("TSG", function(cmdData)
    local argstr = cmdData.args

    local querySearchSep = string.sub(argstr, 1, 1)
    local data = vim.split(argstr, querySearchSep, { plain = true, trimempty = true})

    local query = data[1]
    local cmd = vim.fn.join(vim.list_slice(data, 2), querySearchSep)


    local tsTree = vim.treesitter.get_parser(0, vim.bo.filetype, {})
    local tsQuery = vim.treesitter.query.parse(vim.bo.filetype, query)

    if tsTree == nil then
        return
    end

    for _, tree in pairs(tsTree:trees()) do
        for id, node, meta, match in tsQuery:iter_captures(tree:root(), 0) do
            local srow, scol, erow, ecol = node:range(false)
            local text = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol, {})[1]
            vim.b.nodetxt = text
            -- the user probably wants the ranges in a :command-addr kinda way
            vim.b.noderange = {srow + 1, scol + 1, erow + 1, ecol + 1}
            vim.api.nvim_exec2(cmd, {})
        end
    end
    -- tsQuery:iter_captures(node, source, start?, stop?)

end, {nargs = 1})
