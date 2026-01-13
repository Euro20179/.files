require "oil".setup {
    columns = {
        "icon",
        "permissions"
    },
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        ds = function ()
            vim.cmd[[e oil://$XDG_DOWNLOAD_HOME]]
        end,
        dF = function()
            vim.cmd[[e oil:///$XDG_DOCUMENTS_HOME]]
        end,
        dcg = function()
            vim.cmd[[e oil://$CLOUD/Games]]
        end,
        dc = function()
            vim.cmd[[e oil://$CLOUD]]
        end,
        dm = function()
            vim.cmd[[e oil://$XDG_PICTURES_HOME/memes]]
        end,
        yc = function()
            local dir = require "oil".get_current_dir()
            vim.fn.setreg("\"", dir)
        end
    }
}
