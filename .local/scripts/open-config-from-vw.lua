#!/bin/nvim -S

vim.cmd.cd("${XDG_CONFIG_HOME}")
local items = {}
local dirs = vim.fn.split(vim.fn.execute("!fd --max-depth=1 --type d"), "\n")
local config_home = vim.fn.getenv("XDG_CONFIG_HOME")
--skip the first couple of nonsense lines provided from vim.fn.execute
local i = 3
while i < #dirs do
    local dir = dirs[i]
    items[#items+1] = "[" .. dir .. "]" .. "{/ " .. config_home .. "/" .. dir .. "}"
    i = i + 1
end

local function open_path(path)
    local dirname = vim.fs.dirname(path)
    vim.cmd.cd(vim.fs.dirname(path))
    --if it's the same, open the directory
    if dirname .. "/" == path then
        vim.cmd.edit(".")
    --otherwise there is a specific file that should be opened
    else
        vim.cmd.edit(path)
    end
end

local args = vim.v.argv
local configs = {
    n = "~/.config/nvim/init.lua",
    h = "~/.config/hypr/hyprland.conf",
    w = "~/.config/waybar/config.jsonc",
    f = "~/.config/foot/foot.ini"
}
local name_regex = vim.regex("\\(\\[\\)\\@<=.*\\(\\]\\)\\@=")
local path_regex = vim.regex("\\({/ \\)\\@<=.*\\(}\\)\\@=")
for _, conf in ipairs(items) do
    local nstart, nend = name_regex:match_str(conf)
    local pstart, pend = path_regex:match_str(conf)
    local conf_name = string.lower(string.sub(conf, nstart + 1, nend))
    local path = string.sub(conf, pstart, pend)
    configs[conf_name] = path
    configs[#configs + 1] = conf_name
end
if configs[string.lower(args[#args])] then
    local path = configs[string.lower(args[#args])]
    open_path(path)
else
    vim.ui.select(configs, { prompt = "Select config" }, function(line)
        local path = configs[line]
        vim.schedule(function()
            open_path(path)
        end)
    end)
end
