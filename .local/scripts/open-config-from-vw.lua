#!/bin/nvim -S

vim.cmd.cd("${XDG_CONFIG_HOME}")
local items = {}
local dirs = vim.fn.split(vim.fn.execute("!fd --max-depth=1 --type d"), "\n")
local config_home = vim.fn.getenv("XDG_CONFIG_HOME")
--skip the first couple of nonsense lines provided from vim.fn.execute
local i = 3
while i < #dirs do
    local dir = dirs[i]
    items[#items + 1] = "[" .. dir .. "]" .. "{/ " .. config_home .. "/" .. dir .. "}"
    i = i + 1
end

local function open_path(path)
    path = vim.trim(path)
    local dirname = vim.fs.dirname(path)
    vim.cmd.cd(dirname)
    local files = {}
    for name, type in vim.fs.dir(dirname) do
        files[#files + 1] = name
    end
    if #files == 1 then
        vim.cmd.edit(files[1])
        --if it's the same, open the directory
    elseif dirname .. "/" == path or dirname == path then
        vim.cmd.edit(".")
        --otherwise there is a specific file that should be opened
    else
        vim.cmd.edit(path)
    end
end

local args = vim.v.argv
local configs = {
    n = "~/.config/nvim/init.lua",
    u = "~/.config/nushell/config.nu",
    h = "~/.config/hypr/hyprland.conf",
    w = "~/.config/waybar/config.jsonc",
    f = "~/.config/foot/foot.ini",
    s = "~/.config/.shellrc",
    z = "~/.config/.zshrc",
    v = "~/.config/vim/.vimrc",
    wl = "~/.config/wlinit"
}
local name_regex = vim.regex("\\(\\[\\)\\@<=.*\\(\\]\\)\\@=")
local path_regex = vim.regex("\\({/ \\)\\@<=.*\\(}\\)\\@=")
for _, conf in ipairs(items) do
    local nstart, nend = name_regex:match_str(conf)
    local pstart, pend = path_regex:match_str(conf)
    local conf_name = string.sub(conf, nstart + 1, nend)
    local path = string.sub(conf, pstart, pend)
    configs[conf_name] = path
    configs[#configs + 1] = conf_name
end
if configs[string.lower(args[#args])] or configs[string.lower(args[#args]) .. "/"] then
    local path = configs[string.lower(args[#args])] or configs[string.lower(args[#args]) .. "/"]
    open_path(path)
else
    for k, v in pairs(configs) do
        if type(k) == 'string' then
            configs[k] = nil
        end
    end
    vim.ui.select(configs, { prompt = "Select config" }, function(line)
        --line does not get moved into the vim.schedule callback, instead it gets deleted
        vim.g._t_line = line
        vim.schedule(function()
            if vim.g._t_line == nil then
                vim.cmd[[exit]]
            end
            open_path(vim.fn.getenv("XDG_CONFIG_HOME") .. "/" .. vim.g._t_line)
        end)
    end)
end
