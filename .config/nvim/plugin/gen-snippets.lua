--This program automatically generates a package.json file for the
--snippets folder based on the files that are in the snippets folder
local snippetPath = vim.fn.stdpath("config") .. "/snippets/"

local snippetFiles = vim.fn.readdir(snippetPath)

local outputJson = {
    name = "snippets",
    description = "This package.json has been generated automatically by my config",
    contributes = {
        {
            language = { "all" },
            path = "./all.json"
        }
    }
}

local outputFile = snippetPath .. "package.json"
for i=1,#snippetFiles do
    local file = snippetFiles[i]
    local lang = vim.split(file, ".json")[1]
    outputJson.contributes[#outputJson.contributes+1] = {
        language = { lang },
        path = "./" .. file
    }
end

local handle = vim.uv.fs_open(outputFile, "w", 420)
vim.uv.fs_write(handle, vim.json.encode(outputJson) )
