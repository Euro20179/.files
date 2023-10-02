require("lazy").setup({
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
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
            floating_window = true,
            doc_lines = 0,
            toggle_key = "<c-x>",
            select_signature_key = "<c-z>"
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
    -- use {
    --     "NvChad/nvim-colorizer.lua",
    --     config = function ()
    --         require("colorizer").setup{}
    --         require("colorizer").attach_to_buffer(0, {mode = "foreground", css = true})
    --     end
    -- },
    "drybalka/tree-climber.nvim",
    "folke/which-key.nvim",
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- use "ziontee113/color-picker.nvim",
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
                            }
                        }
                    }
                },
                ["core.ui"] = {},
                ["core.ui.calendar"] = {}
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope",
        }
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.opt.termguicolors = true
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
    -- {
    --     'LukasPietzschmann/telescope-tabs',
    --     config = function()
    --         require "telescope-tabs".setup {
    --         }
    --     end
    -- },
    {
        'nvim-treesitter/playground',
    },
    "uga-rosa/ccc.nvim",
    {
        'windwp/nvim-autopairs',
        config = function()
            require("nvim-autopairs").setup {
            }
        end
    },
    'catppuccin/nvim',
    'smjonas/duplicate.nvim',

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

    "joosepAlviste/nvim-ts-context-commentstring",

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
        "NStefan002/speedtyper.nvim",
        cmd = "Speedtyper",
        opts = {
            game_modes = {
                rain = {
                    throttle = 4
                }
            }
        }
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
    {
        "folke/neodev.nvim",
        config = true
    },
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
        opts = { useDefaultKeymaps = true }
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
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count)
                    return "(" .. count .. ")"
                end,
                themable = true
            },
            highlights = {
                buffer_selected = {
                    bold = true,
                    italic = false
                }
            }
        }
    }
})
