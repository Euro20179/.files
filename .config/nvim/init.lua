vim.loader.enable()
local CONFIG_DIR = vim.fn.getenv("XDG_CONFIG_HOME")
vim.cmd.source(CONFIG_DIR .. "/.vimrc")
require 'functions'
require 'options'
-- require 'init_lazy'
require "plugins2"
require 'snippets'
require 'shortcuts'
require 'autocmd'
-- require 'link-graph'
require 'filetypes'
require 'user.init'
require 'colorscheme'
require "globals-setup"

-- require "discord".setup {
--     token = vim.fn.readfile( "/home/euro/Documents/APIKeys/discord" )[1],
--     user_id = "1190132846409564170"
-- }
