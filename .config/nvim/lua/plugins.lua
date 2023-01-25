require("packer").startup(function(use)
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
    }
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-symbols.nvim'
    use 'joshdick/onedark.vim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'flazz/vim-colorschemes'
    use 'mattn/emmet-vim'
    use 'mbbill/undotree'
    use {
        'L3MON4D3/LuaSnip'
    }
    use 'saadparwaiz1/cmp_luasnip'
    use 'ray-x/lsp_signature.nvim'
    use { 'williamboman/mason.nvim', config = function() require("mason").setup() end }
    use 'tjdevries/nlua.nvim'
    use "folke/neodev.nvim"
    use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end
    }
    use 'dmitmel/cmp-digraphs'
    use { 'akinsho/toggleterm.nvim', tag = 'v2.*',
        config = function() require("toggleterm").setup { direction = 'horizontal' } end }
    use { 'folke/trouble.nvim', config = function() require("trouble").setup {} end,
        requires = "kyazdani42/nvim-web-devicons", }
    use {
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup({})
        end
    }
    -- use "yonlu/omni.vim"
    use "bluz71/vim-nightfly-guicolors"
    -- use "nvim-treesitter/nvim-treesitter-context"
    --use "stevearc/aerial.nvim"
    use "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
    use { 'bennypowers/nvim-regexplainer',
        config = function() require 'regexplainer'.setup({}) end,
        requires = {
            'nvim-treesitter/nvim-treesitter',
            'MunifTanjim/nui.nvim',
        } }
    use "ray-x/aurora"
    -- use {
    --     "NvChad/nvim-colorizer.lua",
    --     config = function ()
    --         require("colorizer").setup{}
    --         require("colorizer").attach_to_buffer(0, {mode = "foreground", css = true})
    --     end
    -- }
    use "drybalka/tree-climber.nvim"
    use "folke/which-key.nvim"
    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    }
    use "nvim-treesitter/nvim-treesitter-textobjects"
    -- use "ziontee113/color-picker.nvim"
    use 'f3fora/cmp-spell'
    use 'superhawk610/ascii-blocks.nvim'
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        config = function()
            require("neorg").setup {
                load = {
                    ["core.integrations.treesitter"] = {},
                    ["core.syntax"]                  = {},
                    ["core.norg.qol.todo_items"]     = {},
                    ["core.norg.esupports.indent"]   = {},
                    ["core.autocommands"]            = {},
                    ["core.norg.esupports.metagen"]  = {},
                    ["core.mode"]                    = {},
                    ["core.norg.qol.toc"]            = {},
                    ["core.norg.esupports.hop"]      = {},
                    ["core.neorgcmd"]                = {},
                    ["core.norg.journal"]            = {},
                    ["core.tangle"]                  = {},
                    ["core.ui"]                      = {},
                    ["core.norg.concealer"]          = {
                        config = {
                        }
                    }
                }
            }
        end,
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope",
        }
    }
    use {
        "rcarriga/nvim-notify"
    }
    use {
        "smjonas/inc-rename.nvim",
        config = function()
            require("inc_rename").setup {}
        end
    }
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                attach_to_untracked = false,
            }
        end
    }
    use {
        'folke/tokyonight.nvim'
    }
    use {
        'LukasPietzschmann/telescope-tabs',
        config = function()
            require "telescope-tabs".setup {
            }
        end
    }
    use 'lewis6991/impatient.nvim'
    use {
        'nvim-treesitter/playground',
    }
    use "uga-rosa/ccc.nvim"
    -- use "mfussenegger/nvim-dap"
    -- use {
    --     "rcarriga/nvim-dap-ui",
    --     requires = { "mfussenegger/nvim-dap" },
    --     config = function()
    --         require "dapui".setup {
    --             icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    --             controls = {
    --                 -- Requires Neovim nightly (or 0.8 when released)
    --                 enabled = true,
    --                 -- Display controls in this element
    --                 element = "repl",
    --                 icons = {
    --                     pause = "",
    --                     play = "",
    --                     step_into = "",
    --                     step_over = "",
    --                     step_out = "",
    --                     step_back = "",
    --                     run_last = "🔄",
    --                     terminate = "□",
    --                 },
    --             },
    --         }
    --     end
    -- }
    -- use {
    --     "mxsdev/nvim-dap-vscode-js",
    --     requires = {
    --         "mfussenegger/nvim-dap"
    --     }
    -- }
    use {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npm run compile"
    }
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end
    }
    use 'ms-jpq/chadtree'
    use 'f-person/git-blame.nvim'
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require("nvim-autopairs").setup{
            }
        end
    }
    use 'catppuccin/nvim'
    use 'sindrets/diffview.nvim'
    use 'smjonas/duplicate.nvim'
end)
