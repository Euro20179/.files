vim.cmd.norm[[zR]]
vim.g._outline_cmd = "Neorg toc"
require "mini.deps".now(function()
    require "neorg".setup {
        load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {
                config = {
                    icons = {
                        todo = {
                            on_hold = {
                                icon = "󰏤"
                            },
                        },
                        heading = {
                            icons = { "󰉫", "󰉬", "󰉭", "󰉮", "󰉯", "󰉰" }
                        }
                    }
                }
            },
            ["core.ui"] = {},
            ["core.ui.calendar"] = {},
            ["external.exec"] = {},
            ["core.queries.native"] = {},
            ["core.integrations.treesitter"] = {},
        }
    }
end)
