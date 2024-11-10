vim.loader.enable()

require 'user.functions'
require 'user.options'
require "user.plugins2"
require 'user.snippets'
require 'user.shortcuts'
require 'user.autocmd'
-- require 'link-graph'
require 'user.filetypes'
require 'user.init'
require 'user.colorscheme'
require "user.globals-setup"
-- require "discord-ui".setup {
--    token = vim.fn.readfile( "/home/euro/Documents/APIKeys/discord2" )[1],
--    user_id = "1190132846409564170"
-- }
--
-- require"matrix.config".set_config({
--     homeserver = "https://matrix.org",
-- })

require"blink-cmp".setup {
        highlight = {
            ns = vim.api.nvim_create_namespace("blink_cmp"),
            use_nvim_cmp_as_default = true
        },
        keymap = {
            preset = "default",
            ["<c-q>"] = { "show", "hide" },
            ["<c-l>"] = { "accept" },
            ["<c-n>"] = { "select_next" },
            ["<c-p>"] = { "select_prev" },
            ["<C-u>"] = { "scroll_documentation_up" },
            ["<C-d>"] = { "scroll_documentation_down" },
            ["<c-,>"] = { "show_documentation", "hide_documentation" },
        },
        kind_icons = {
            Text = "",
            Method = " ",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "𝑥",
            Class = "",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "󱄽",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = ""
        },

        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer" }
            },
        },
        trigger = {
            completion = {
                keyword_regex = "[%w#_\\-]"
            }
        },
        windows = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
            },
            ghost_text = {
                enabled = true
            }
        }
    }
