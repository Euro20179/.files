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
    'hrsh7th/nvim-cmp',
    "dcampos/cmp-emmet-vim",
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'flazz/vim-colorschemes',
    'mattn/emmet-vim',
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
        config = function()
            require("mason").setup()
        end
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end
    },
    {
        'folke/trouble.nvim',
        config = function() require("trouble").setup {} end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "kylechui/nvim-surround",
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
    "ray-x/aurora",
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
    -- use {
    --     "nvim-neorg/neorg",
    --     run = ":Neorg sync-parsers",
    --     config = function()
    --         require("neorg").setup {
    --             load = {
    --                 ["core.integrations.treesitter"] = {},
    --                 ["core.syntax"]                  = {},
    --                 ["core.norg.qol.todo_items"]     = {},
    --                 ["core.norg.esupports.indent"]   = {},
    --                 ["core.autocommands"]            = {},
    --                 ["core.norg.esupports.metagen"]  = {},
    --                 ["core.mode"]                    = {},
    --                 ["core.norg.qol.toc"]            = {},
    --                 ["core.norg.esupports.hop"]      = {},
    --                 ["core.neorgcmd"]                = {},
    --                 ["core.norg.journal"]            = {},
    --                 ["core.tangle"]                  = {},
    --                 ["core.ui"]                      = {},
    --                 ["core.queries.native"]          = {},
    --                 ["core.norg.concealer"]          = {
    --                 ["core.presenter"]               = {},
    --                     config = {
    --                     }
    --                 }
    --             }
    --         }
    --     end,
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-neorg/neorg-telescope",
    --     }
    -- }
    {
        "rcarriga/nvim-notify",
        config = function ()
            vim.opt.termguicolors = true
            require("notify").setup{
                background_colour = "#000000"
            }
        end
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                signature = {
                    enabled = false
                },
            },
            messages = {
                enabled = false
            }
        },
        dependencies = {
            "rcarriga/nvim-notify",
            "MunifTanjim/nui.nvim"
        }
    },
    {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup {}
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                attach_to_untracked = false,
            }
        end
    },
    {
        'folke/tokyonight.nvim'
    },
    {
        'LukasPietzschmann/telescope-tabs',
        config = function()
            require "telescope-tabs".setup {
            }
        end
    },
    {
        'nvim-treesitter/playground',
    },
    "uga-rosa/ccc.nvim",
    'ms-jpq/chadtree',
    -- 'f-person/git-blame.nvim',
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
        'michaelb/sniprun', run = 'bash ./install.sh'
    },

    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("diffview").setup {}
        end
    },

    "joosepAlviste/nvim-ts-context-commentstring",

    "kelly-lin/ranger.nvim",

    "simrat39/symbols-outline.nvim",
    { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },


    "willothy/moveline.nvim",
    {
        "debugloop/telescope-undo.nvim"
    },

    {
        "Apeiros-46B/qalc.nvim",
        config = function()
            require("qalc").setup {}
        end
    },

    "alec-gibson/nvim-tetris",
    {
        "NStefan002/speedtyper.nvim",
        cmd = "Speedtyper"
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
        "andersevenrud/nvim_context_vt",
        config = function()
            require("nvim_context_vt").setup { enabled = true }
        end
    },
})
