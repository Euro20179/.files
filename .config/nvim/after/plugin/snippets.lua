local config_dir = vim.fn.stdpath('config')

local snippet_prefixes = {}

function Get_snippets(findstart, base)
    if findstart == 1 then
        local kwd = ""
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".") - 1

        while vim.fn.match(string.sub(line, col, col), "\\k") ~= -1 do
            kwd = string.sub(line, col, col) .. kwd
            col = col - 1
        end

        if kwd == "" then return -3 end
        return col
    end

    local matches = {}
    for p, b in pairs(snippet_prefixes) do
        if not vim.startswith(p, base) then goto continue end

        matches[#matches+1] = p

        ::continue::
    end

    return {
        words = vim.iter(matches)
                    :map(function(w) return snippet_prefixes[w] end)
                    :totable()
    }
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local ft = vim.bo.ft

        local file = vim.fs.find(ft .. ".json", {
            path = config_dir .. '/snippets'
        })

        if #file < 1 then
            return
        end

        local lines = vim.fn.readfile(file[1])
        local text = table.concat(lines, "\n")
        local snippets = vim.json.decode(text, {})

        for k, v in pairs(snippets) do
            snippet_prefixes[v['prefix']] = v['body']
        end

        vim.bo.completefunc = 'v:lua.Get_snippets'
    end
})
