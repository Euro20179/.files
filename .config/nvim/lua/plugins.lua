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
                    },
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
        'williamboman/mason.nvim',
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
        config = function()
            require("mason").setup()
        end
    },
    "bluz71/vim-nightfly-guicolors",
    "https://github.com/nvim-treesitter/nvim-treesitter-refactor",
    "drybalka/tree-climber.nvim",
    "folke/which-key.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    'superhawk610/ascii-blocks.nvim',
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
    {
        "uga-rosa/ccc.nvim",
        cmd = { "CccPick", "CccConvert" },
        config = function()
            local ccc = require("ccc")
            if vim.o.binary == false then
                local mapping = ccc.mapping
                ccc.setup {
                    inputs = {
                        ccc.input.hsl,
                        ccc.input.rgb
                    },
                    highlighter = {
                        auto_enable = true
                    },
                    mappings = {
                        ["$"] = mapping.set100
                    }
                }
            end
        end
    },
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
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        lazy = true,
        opts = {
            position = "left",
            show_numbers = true,
            show_relative_Numbers = true,
            symbols = {
                Boolean = { icon = "", hl = "@boolean" },
                Array = { icon = "", hl = "@constant" },
                String = { icon = "", hl = "@string" },
                Function = { icon = "", hl = "@function" },
                File = { icon = "", hl = "@text.uri" },
                Module = { icon = "", hl = "@namespace" },
                Class = { icon = "", hl = "@type" },
                Method = { icon = " ", hl = "@method" },
                Property = { icon = "", hl = "@method" },
                Field = { icon = "", hl = "@field" },
                Constructor = { icon = "", hl = "@constructor" },
                Enum = { icon = "", hl = "@type" },
                Interface = { icon = "", hl = "@type" },
                Variable = { icon = "𝑥", hl = "@constant" },
                Constant = { icon = "", hl = "@constant" },
                EnumMember = { icon = "", hl = "@field" },
                Struct = { icon = "", hl = "@type" },
                Event = { icon = "", hl = "@type" },
                Operator = { icon = "", hl = "@operator" },
                TypeParameter = { icon = "", hl = "@parameter" },
            },
            keymaps = {
                hover_symbol = "glh"
            }
        }
    },
    { "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
    -- {
    --     "andymass/vim-matchup"
    -- },
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
            disabledKeymaps = { "ik", "ak", "iv", "av", "!", "gc", "Q" }
        },
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
        "mxsdev/nvim-dap-vscode-js",
        ft = { "javascript", "typescript" }
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
                                args = { "ysi% " }
                            }, {})
                        end
                    }
                }
            }
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
        dir = "~/Programs/GithubContribs/nvim-snippets/",
        opts = true
    },
    -- {
    --     --in order to get this to work with lazy, I had to create a symlink to nvim-snippets called "snippets" in the lazy/nvim-snippets/lua folder.
    --     "garymjr/nvim-snippets",
    --     config = function()
    --         require "nvim-snippets".setup {}
    --     end
    -- },
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        lazy = true,
        opts = {
            window = {
                winblend = 5
            }
        },
    },
    {
        dir = "~/.config/nvim/model.nvim/",
        cmd = { "MChat", "Model", "Myank", "M", "Mshow", "Mcount", "Mdelete", "Mselect", "Mstore", "Mcancel" },
        lazy = true,
        config = function()
            require "model".setup {
                prompts = {
                    complete = {
                        provider = require "model.providers.ollama",
                        params = {
                            model = "codellama"
                        },
                        builder = function(input)
                            return {
                                prompt =
                                    "[INST] <<SYS>>You try to predict what code would come next, do not output anything other than code<</SYS>>\n\n" ..
                                    input .. " [/INST]"
                            }
                        end
                    },
                    completeS = {
                        provider = require "model.providers.ollama",
                        params = {
                            model = "starcoder"
                        },
                        builder = function(input)
                            return {
                                prompt = input
                            }
                        end
                    },
                    ["complete13"] = {
                        provider = require "model.providers.ollama",
                        params = {
                            model = "codellama:13b-code"
                        },
                        builder = function(input)
                            return {
                                prompt = input
                            }
                        end
                    }
                }
            }
        end
    },
    {
        "kevinhwang91/nvim-bqf"
    },
    {
        "stevearc/oil.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            default_file_explorer = true,
            view_options = {
                show_hidden = true
            },
            columns = {
                "icon"
            }
        }
    },
    {
        "jbyuki/quickmath.nvim"
    }
})
