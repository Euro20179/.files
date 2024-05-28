vim.loader.enable()
-- local VIM_CONFIG_DIR = vim.fn.getenv("XDG_CONFIG_HOME")
-- vim.cmd.source(VIM_CONFIG_DIR .. "/vim/.vimrc")

require 'functions'
require 'options'
-- require 'init_lazy'
require "plugins2"
-- require"plugins3"
require 'snippets'
require 'shortcuts'
require 'autocmd'
-- require 'link-graph'
require 'filetypes'
require 'user.init'
require 'colorscheme'
require "globals-setup"

require "discord-ui".setup {
   token = vim.fn.readfile( "/home/euro/Documents/APIKeys/discord2" )[1],
   user_id = "1190132846409564170"
}
