local sk = vim.lsp.protocol.SymbolKind
require("lazy").setup({
    'nvim-treesitter/nvim-treesitter',
    "nvim-telescope/telescope-ui-select.nvim",
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            local tele = require "telescope"
            tele.setup {
                extensions = {
                    ["ui-select"] = {
                        require "telescope.themes".get_dropdown {}
                    }
                }
            }
            tele.load_extension("ui-select")
        end
    },
    'nvim-telescope/telescope-symbols.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'hrsh7th/nvim-cmp',
    'flazz/vim-colorschemes',
    {
        'ray-x/lsp_signature.nvim',
        config = true,
        main = "lsp_signature",
        opts = {
            bind = true,
            hint_enable = false,
            hint_prefix = " ",
            always_trigger = false,
            doc_lines = 0,
            toggle_key = "<c-b>",
            select_signature_key = "<c-s><c-z>",
            move_cursor_key = "<c-s><c-s>"
        }
    },
    {
        'williamboman/mason.nvim',
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
        config = function()
            require("mason").setup()
        end
    },
    {
        'folke/trouble.nvim',
        config = function() require("trouble").setup {} end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    "bluz71/vim-nightfly-guicolors",
    "https://github.com/nvim-treesitter/nvim-treesitter-refactor",
    {
        'bennypowers/nvim-regexplainer',
        config = function() require 'regexplainer'.setup({}) end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'MunifTanjim/nui.nvim',
        }
    },
    "drybalka/tree-climber.nvim",
    "folke/which-key.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    'superhawk610/ascii-blocks.nvim',
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig"
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        ft = "norg",
        opts = {
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
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope",
            "laher/neorg-exec",
        }
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup {}
        end
    },
    {
        'folke/tokyonight.nvim'
    },
    "uga-rosa/ccc.nvim",
    'catppuccin/nvim',

    {
        'michaelb/sniprun',
        build = 'bash ./install.sh',
        opts = {
            live_mode_toggle = 'enable'
        }
    },
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        lazy = true,
        cmd = { "DiffviewOpen" },
        opts = {}
    },
    { "simrat39/symbols-outline.nvim",  cmd = "SymbolsOutline", lazy = true },
    { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
    {
        "andymass/vim-matchup"
    },
    {
        "jinh0/eyeliner.nvim",
        event = "VeryLazy",
        config = function()
            require 'eyeliner'.setup {
                highlight_on_key = true,
                dim = true
            }
        end
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        lazy = false,
        opts = {
            useDefaultKeymaps = true,
            disabledKeymaps = { "ik", "ak", "iv", "av", "!", "gc" }
        },
    },
    {
        "LukasPietzschmann/telescope-tabs"
    },
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        config = true
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            event_handlers = {
                {
                    event = "file_open_requested",
                    handler = function(arg)
                        vim.fn.setenv("LH_NO_EDIT", "1")
                        local res = vim.system({ "linkhandler", arg.path }):wait()
                        if res.code == 1 then
                            return { handled = false }
                        end
                        return { handled = true }
                    end
                }
            },
            filesystem = {
                hijack_netrw_behavior = "open_current"
            }
        }
    },
    "nvim-lualine/lualine.nvim",
    "arkav/lualine-lsp-progress",
    {
        "mfussenegger/nvim-dap"
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        opts = {}
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2"
    },
    {
        "cshuaimin/ssr.nvim",
        module = "ssr",
        -- Calling setup is optional.
        config = function()
            require("ssr").setup {
                border = "rounded",
                min_width = 50,
                min_height = 5,
                max_width = 120,
                max_height = 25,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_confirm = "<cr>",
                    replace_all = "<leader><cr>",
                },
            }
        end
    },
    {
        "mxsdev/nvim-dap-vscode-js"
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            -- require "mini.pairs".setup {}
            require "mini.comment".setup {}
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
                    add = 'ys',
                    delete = 'ds',
                    find = 'Yf',
                    find_left = 'YF',
                    highlight = 'Yh',
                    replace = 'cs',
                    update_n_lines = 'Yn'
                }
            }
            require "mini.splitjoin".setup {
                join = {
                    hooks_post = {
                        function()
                            vim.api.nvim_cmd({
                                cmd = "norm",
                                args = { "ysib " }
                            }, {})
                        end
                    }
                }
            }
            require "mini.notify".setup {}
            require "mini.indentscope".setup {
                delay = 0
            }
            require "mini.bracketed".setup {}
            require "mini.operators".setup {
                exchange = {
                    prefix = "yx"
                },
                multiply = {
                    prefix = "yd"
                },
                replace = {
                    prefix = "yr"
                }
            }
        end
    },
    {
        "luckasRanarison/tree-sitter-hypr"
    },
    {
        "altermo/ultimate-autopair.nvim",
        opts = {}
    },
    {
        "dustinblackman/oatmeal.nvim",
        cmd = { "Oatmeal" },
        keys = {
            { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
        },
        opts = {
            backend = "ollama",
            model = "codellama:latest",
        },
    },
    {
        "patrickpichler/hovercraft.nvim",
        config = function()
            require "hovercraft".setup {}
            ---@diagnostic disable-next-line
            vim.lsp.buf.hover = function(...)
                local hovercraft = require "hovercraft"
                if hovercraft.is_visible() then
                    hovercraft.enter_popup()
                else
                    hovercraft.hover({ current_provider = "LSP" })
                end
            end
        end
    },
    {
        "garymjr/nvim-snippets",
        config = function()
            require "nvim-snippets".setup {}
        end
    },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            window = {
                winblend = 5
            }
        },
        keys = { -- load the plugin only when using it's keybinding:
            { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },
    {
        "Nedra1998/nvim-mdlink",
        opts = {
            keymap = true,
            cmp = true
        }
    },
    {
        "VidocqH/lsp-lens.nvim",
        opts = {
            sections = {
                git_authors = false,
                definitions = false,
                references = true,
                implements = false
            },
            target_symbol_kinds = {sk.Class, sk.Method, sk.Enum, sk.Function, sk.Struct, sk.Object},
            wrapper_symbol_kinds = {sk.Class, sk.Struct, sk.Enum, sk.Object}
        }
    },
    {
        "altermo/nxwm",
        opts = {
            on_win_open = function (buf)
                vim.api.nvim_set_current_buf(buf)
            end
        }
    },
})
