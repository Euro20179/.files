-- because of some weird config loading things
-- -u <(echo) must be provided so nvim loads filetypes
-- example usage: `nvim -u <(echo) -l file-detect.lua ./the-file-to-detect`

local file = vim.v.argv[#vim.v.argv]

local f = io.open(file, "r")
if f == nil then
    return
end
local lines = vim.split(f:read("*a"), "\n")
f:close()
vim.api.nvim_buf_set_lines(0, 0, 1, false, lines)
vim.api.nvim_buf_set_name(0, file)

local buf = vim.api.nvim_win_get_buf(0)
local res, f = vim.filetype.match({buf = buf})
io.stdout:write(tostring(res))
