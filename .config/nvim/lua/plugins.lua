local key = vim.fn.readfile("/home/euro/Documents/APIKeys/hggf.key")[1]
require("lazy").setup({
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    "nvim-telescope/telescope-ui-select.nvim",
    {
        'nvim-telescope/telescope.nvim',
        config = function()
            require "telescope".setup {

                extensions = {
                    ["ui-select"] = {
                        require "telescope.themes".get_dropdown {}
                    }
                }
            }
            require "telescope".load_extension("ui-select")
        end
    },
    'nvim-telescope/telescope-symbols.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'hrsh7th/nvim-cmp',
    -- 'L3MON4D3/LuaSnip',
    -- 'saadparwaiz1/cmp_luasnip',
    'flazz/vim-colorschemes',
    {
        'ray-x/lsp_signature.nvim',
        config = true,
        main = "lsp_signature",
        opts = {
            bind = true,
            hint_enable = true,
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
    -- {
    --     "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end
    -- },
    {
        'folke/trouble.nvim',
        config = function() require("trouble").setup {} end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    -- use "yonlu/omni.vim"
    "bluz71/vim-nightfly-guicolors",
    -- use "nvim-treesitter/nvim-treesitter-context"
    --use "stevearc/aerial.nvim"
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
    'f3fora/cmp-spell',
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
                ["external.exec"] = {}
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope",
            "laher/neorg-exec"
        }
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.opt.termguicolors = true
            vim.notify = require "notify"
            require("notify").setup {
                background_colour = "#000000"
            }
        end
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup {}
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            attach_to_untracked = false,
        }
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

    { "simrat39/symbols-outline.nvim",  cmd = "SymbolsOutline" },
    { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },


    {
        "debugloop/telescope-undo.nvim"
    },

    {
        "alec-gibson/nvim-tetris",
        cmd = "Tetris"
    },
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        config = function()
            require "glow".setup {
                glow_path = "/usr/bin/glow",
            }
        end
    },
    {
        'jim-fx/sudoku.nvim',
        cmd = "Sudoku",
        config = true
    },
    {
        "jinzhongjia/LspUI.nvim",
        config = true
    },
    -- {
    --     "folke/neodev.nvim",
    --     config = true
    -- },
    {
        "EdenEast/nightfox.nvim"
    },
    {
        "andymass/vim-matchup"
    },
    {
        "/nvimdev/template.nvim",
        cmd = { "Template", "TemProject" },
        opts = {
            temp_dir = "~/.config/nvim/template"
        }
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
        "3rd/image.nvim",
        cmd = "DisplayImg",
        ft = { "markdown", "neorg" },
        opts = {
            backend = "ueberzug"
        }
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
                        local res = vim.system({"linkhandler", arg.path}):wait()
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
        config = function()
            local harpoon = require "harpoon"
            local mark = require "harpoon.mark"
            harpoon.setup {}
            mark.clear_all()
        end
    },
    {
        "shaunsingh/nord.nvim"
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
        "space-chalk/spacechalk.nvim"
    },
    {
        "pineapplegiant/spaceduck"
    },
    {
        "polirritmico/monokai-nightasty.nvim"
    },
    {
        "mxsdev/nvim-dap-vscode-js"
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            require "mini.pairs".setup {}
            require "mini.comment".setup {}
            require "mini.ai".setup {}
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
            require "mini.indentscope".setup {
                delay = 0
            }
            require "mini.operators".setup {
                exchange = {
                    prefix = "yx"
                },
                multiply = {
                    prefix = "yd"
                }
            }
        end
    },
    {
        "ThePrimeagen/refactoring.nvim",
        opts = {}
    },
})
