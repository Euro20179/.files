vim.cmd.packadd "pkg"
local pkg = require "pkg"

vim.o.pp = vim.o.pp .. ',' .. vim.fn.expand("$HOME/Programs/Coding Projects/neovim-plugins")


-- mmfml plugin can be found: https://static.seceurity.place/git/nvim-mmfml
-- gemini plugin can be found: https://github.com/euro20179/nvim-gemini
-- div can be found: https://github.com/Euro20179/div.nvim
for _, plug in pairs({
    "nvim.difftool",
    "nvim.undotree",
    "mmfml",
    "gemini",
    "div",
    "find-highlight",
    "discord",
    "discord-ui",
    "irc.nvim",
    "enc-notes"
}) do
    -- :packadd! = do not source plugin/*
    -- because plug is added to &rtp meaning it will get sourced anyway
    vim.cmd.packadd { plug, bang = true }
end

--libraries{{{
pkg.add({
    {
        src = "https://github.com/nvim-lua/plenary.nvim",
    },
    {
        src = "https://github.com/nvim-tree/nvim-web-devicons"
    }
}, "now")
--}}}

-- Treesitter{{{
pkg.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", rev = "main", branches = { "main" }, version = "main" },
    -- { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" }
}, "now")
-- }}}

--LSP+DAP{{{

pkg.add({
    { src = "https://github.com/b0o/Schemastore.nvim" },
    { src = "https://github.com/icholy/lsplinks.nvim" }
}, "now", {
    on_add = function()
        require "lsplinks".setup {}
        vim.keymap.set("n", "gx", require "lsplinks".gx)
    end
})

function BuildBlink()
    local blink_cmp_path = vim.fn.expand("$XDG_DATA_HOME/nvim/site/pack/core/opt/blink.cmp")
    vim.notify("Please wait while blink is being build")
    vim.system({ "cargo", "build", "--release", "--manifest-path", blink_cmp_path .. "/Cargo.toml" }, {},
        function(res)
            vim.schedule(function()
                if res.code ~= 0 then
                    vim.notify(tostring(res.stderr))
                else
                    vim.notify("Built blink cmp")
                end
            end)
        end
    )
end

pkg.add({
    { src = "https://github.com/Saghen/blink.cmp" }
}, "now", {
    on_add = function()
        require "blink.cmp".setup {
            completion = {
                menu = {
                    draw = {
                        treesitter = {
                            "lsp",
                        }
                    }
                },

                keyword = {
                    range = "prefix",
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    update_delay_ms = 50
                },

                ghost_text = {
                    enabled = false
                },

                accept = {
                    auto_brackets = {
                       enabled = false
                    }
                }
            },

            keymap = {
                preset = "default",
                ["<Tab>"] = {},
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<c-q>"] = { "show", "hide" },
                ["<c-l>"] = { "accept" },
                ["<c-n>"] = { "select_next" },
                ["<c-p>"] = { "select_prev" },
                ["<C-b>"] = { "scroll_documentation_up" },
                ["<C-f>"] = { "scroll_documentation_down" },
                ["<c-,>"] = { "show_documentation", "hide_documentation" },
            },
            appearance = {
                highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
                use_nvim_cmp_as_default = true,
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
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            fuzzy = {
                frecency = {
                    enabled = true
                }
            }
        }
    end
})


pkg.add({
    {
        src = "https://github.com/williamboman/mason.nvim"
    }
}, "now", {
    on_add = function()
        require("mason").setup {}
    end
})
--}}}

-- Themes {{{
pkg.add { { src = "https://github.com/catppuccin/nvim" } }
-- }}}

-- Navigation {{{

pkg.add({
    { src = "https://github.com/kevinhwang91/nvim-bqf" }
}, "now", {
    on_add = function()
        require "bqf".setup {}
    end
})

pkg.add({ { src = "https://github.com/stevearc/oil.nvim" } }, "now", {
    on_add = function()
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
    end
})
-- }}}

-- Mini{{{
pkg.add({ { src = "https://github.com/echasnovski/mini.nvim" } }, "now", {
    on_add = function()
        require "mini.move".setup {
            mappings = {
                left = "<a-h>",
                right = "<a-l>",
                down = "<a-j>",
                up = "<a-k>",

                line_left = "<Plug>",
                line_right = "<plug>",
                line_down = "<plug>",
                line_up = "<plug>",
            }
        }

        require "mini.surround".setup {
            custom_surroundings = {
                T = {
                    output = function()
                        local name = require "mini.surround".user_input("Name of template type")
                        return { left = name .. "<", right = ">" }
                    end
                },
            },
            mappings = {
                add = '<leader>s',
                delete = 'ds',
                find = '<plug>',
                find_left = '<plug>',
                highlight = '<plug>',
                replace = 'cs',
                update_n_lines = '<plug>'
            }
        }

        require "mini.splitjoin".setup {}

        require "mini.operators".setup {
            exchange = {
                prefix = "<leader>x"
            },
            multiply = {
                prefix = "<Plug>" --also disable, never use it
            },
            replace = {
                prefix = "<leader>r"
                --more portable, possibly make own version to use <reg>yr<motion>
            },
            sort = {
                prefix = '<Plug>' --disable sort feature, by setting an inacessable key
            }
        }

        require "mini.pick".setup {
            window = {
                config = function()
                    return {
                        width = vim.o.columns - 30
                    }
                end
            }
        }
    end
})
-- }}}

pkg.add({
    {
    src = "https://github.com/wakatime/vim-wakatime"
    },
})

pkg.add({
    {
        src = "https://github.com/3rd/sqlite.nvim"
    },
    { src = "https://github.com/Apeiros-46B/qalc.nvim", version = "451f082" },
    { src = "https://github.com/tpope/vim-fugitive" },
}, "now")
