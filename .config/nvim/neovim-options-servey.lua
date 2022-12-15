-- Get Neovim version
local version = vim.version()
if version.major == 0 and version.minor < 7 then error('This script needs at least Neovim 0.7.') end

-- Create scratch buffer to better track options and paste output lines
local buf_id = vim.api.nvim_create_buf(true, true)
vim.api.nvim_set_current_buf(buf_id)

-- Define "bad" (non-transferable) options
--stylua: ignore
local bad_options = {
  -- Current GUI options
  'columns', 'lines', 'scroll', 'window',

  -- Related to paths (not safe to transfer)
  'cdpath', 'packpath', 'path', 'runtimepath',
  'backupdir', 'directory', 'viewdir', 'undodir',
  'helpfile', 'spellfile',
  'backupskip',
  'dictionary',

  -- Only buffer-local which are fixed for current scratch buffer
  'buftype', 'swapfile', 'modeline',
}

-- Start creating output lines
local lines = { '---Please copy all lines---' }

-- Add Neovim version
table.insert(lines, string.format('neovim_version,%d.%d.%d', version.major, version.minor, version.patch))

-- Add leader key
table.insert(lines, 'leader,' .. vim.inspect(vim.g.mapleader))

-- Add non-default options
local option_lines = {}
for name, info in pairs(vim.api.nvim_get_all_options_info()) do
  local has_value, value = pcall(vim.api.nvim_get_option_value, name, {})
  local is_ok_option = has_value and value ~= info.default and not vim.tbl_contains(bad_options, name)
  if is_ok_option then table.insert(option_lines, string.format('%s,%s', name, vim.inspect(value))) end
end
table.sort(option_lines)
vim.list_extend(lines, option_lines)

-- Set lines
table.insert(lines, '---Please copy all lines---')
vim.api.nvim_buf_set_lines(buf_id, 0, -1, true, lines)
