if vim.fn.findfile("${XDG_CONFIG_HOME}/vim/vimrc") ~= "" then
    vim.cmd.source("${XDG_CONFIG_HOME}/vim/vimrc")
elseif vim.fn.findfile("~/.vimrc") ~= "" then
    vim.cmd.source("~/.vimrc")
end

vim.loader.enable()

require 'user.plugins2'

local g = require"gemini"

g.setup{
    bookmark_file = vim.fn.stdpath("config") .. "/gemini-bookmarks",
    certificates = {
        ["bbs.geminispace.org"] = {
            cert = "~/.local/share/amfora/geminispace-org-cert.pem",
            key = "~/.local/share/amfora/geminispace-org-key.pem",
        }
    }
}

-- g.addmime("text/x-mmfml", "mmfml")
--
-- require "discord-ui".setup {
--    token = vim.fn.readfile( "/home/euro/Documents/APIKeys/discord2" )[1],
--    user_id = "1190132846409564170"
-- }
--
-- require"matrix.config".set_config({
--     homeserver = "https://matrix.org",
-- })
--
--
