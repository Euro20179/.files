local config_dir = vim.fn.stdpath('config')

local snippet_prefixes = {}

local function get_snippets()
    local kwd = ""
    local line = vim.fn.getline(".")
    local col = vim.fn.col(".") - 1

    while vim.fn.match(string.sub(line, col, col), "\\k") ~= -1 do
        kwd = string.sub(line, col, col) .. kwd
        col = col - 1
    end

    if kwd == "" then return end

    local matches = {}
    for p, b in pairs(snippet_prefixes) do
        if not vim.startswith(p, kwd) then goto continue end

        matches[#matches+1] = p

        ::continue::
    end

    if #matches == 1 then
        vim.cmd.norm"diw"
        vim.snippet.expand(snippet_prefixes[matches[1]])
    else
        vim.ui.select(matches, {
            prompt = "snippet",
        }, function(item)
            if item == nil then return end
            vim.snippet.expand(item)
        end)
    end
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

        vim.keymap.set("i", "<c-s-s>", get_snippets)
    end
})
