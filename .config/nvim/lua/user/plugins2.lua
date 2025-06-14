--bootstrap {{{
local path_package = vim.fn.stdpath("data") .. "/site/"

local mini_path = path_package .. "pack/deps/start/mini.nvim"

if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        "https://github.com/echasnovski/mini.nvim", mini_path
    })
    vim.cmd("packadd mini.nvim | helptags ALL")
end

require "mini.deps".setup({ path = { package = path_package } })
--}}}

vim.cmd.packadd "cfilter"
vim.cmd.packadd { "termdebug", bang = true }

local miniDeps = require "mini.deps"
local add = miniDeps.add
local later = miniDeps.later
local now = miniDeps.now

local function setup(when, name, opts)
    when(function()
        require(name).setup(opts)
    end)
end
local function aSetup(addOpts, when, name, opts)
    add(addOpts)
    setup(when, name, opts)
end

-- aSetup({
--     source = "nvzone/typr", depends = { "nvzone/volt" },
-- }, later, "typr", {})

--libraries{{{
add { source = "nvim-lua/plenary.nvim" }
add { source = "nvim-tree/nvim-web-devicons" }
-- add { source = "MunifTanjim/nui.nvim" }
-- add { source = "nvim-neotest/nvim-nio" }
--}}}

-- Treesitter{{{
add { source = "nvim-treesitter/nvim-treesitter" }
add { source = "nvim-treesitter/nvim-treesitter-textobjects" }
-- }}}

--LSP+DAP{{{

add { source = "b0o/Schemastore.nvim" }

aSetup({ source = "icholy/lsplinks.nvim" }, later, "lsplinks", {})

local function buildBlink()
    local blink_cmp_path = vim.fn.expand("$XDG_DATA_HOME/nvim/site/pack/deps/opt/blink.cmp")
    vim.system({ "cargo", "build", "--release", "--manifest-path", blink_cmp_path .. "/Cargo.toml" }, {},
        function(res)
            vim.schedule(function()
                vim.notify("Please wait while blink is being built...")
                if res.code ~= 0 then
                    vim.notify(tostring(res.stderr))
                else
                    vim.notify("Built blink cmp")
                end
            end)
        end
    )
end

aSetup({
        source = "Saghen/blink.cmp",
        -- source = "file:///home/euro/Programs/GithubContribs/blink.cmp",
        depends = { 'rafamadriz/friendly-snippets' },
        hooks = {
            post_checkout = buildBlink,
            post_install = buildBlink,
        }
    }, later,
    "blink-cmp", {
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
            ["<C-f>"] = { "scroll_documentation_up" },
            ["<C-b>"] = { "scroll_documentation_down" },
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
            use_frecency = false,
        }
    }
)

-- add { source = "mfussenegger/nvim-dap" }
-- add { source = "mxsdev/nvim-dap-vscode-js" }
-- aSetup({ source = "rcarriga/nvim-dap-ui" }, later, "dapui", {})

aSetup({ source = "williamboman/mason.nvim" }, later, "mason", {})
--}}}

-- Themes {{{
for _, theme in pairs({
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "dgox16/oldworld.nvim",
    "xero/evangelion.nvim",
    "bluz71/vim-moonfly-colors",
    "savq/melange-nvim",
    "rmehri01/onenord.nvim",
    "loctvl842/monokai-pro.nvim"
}) do
    add { source = theme }
end
-- }}}

-- Navigation {{{

-- aSetup({ source = "nvim-zh/colorful-winsep.nvim" }, later, "colorful-winsep", {
--     hi = {
--         fg = "#f4b8e4"
--     }
-- })

aSetup({ source = "kevinhwang91/nvim-bqf" }, later, "bqf", {})
add { source = "theprimeagen/harpoon", monitor = "harpoon2", checkout = "harpoon2" }

aSetup({ source = "stevearc/oil.nvim" }, now, "oil", {
    columns = {
        "icon",
        "permissions"
    },
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        yc = function()
            local dir = require "oil".get_current_dir()
            vim.fn.setreg("\"", dir)
        end
    }
})
-- }}}

-- Neorg {{{
-- add { source = "nvim-neorg/neorg",
--     depends = {
--         "pysan3/pathlib.nvim",
--         "vhyrro/luarocks.nvim",
--         "nvim-neorg/lua-utils.nvim"
--     }
-- } -- }}}

-- Mini{{{
add { source = "echasnovski/mini.nvim" }

later(function()
    -- require "mini.comment".setup {}
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

    require "mini.indentscope".setup {
        delay = 0
    }

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

    vim.ui.select = require "mini.pick".ui_select
end) -- }}}

-- add { source = "altermo/ultimate-autopair.nvim" }
-- later(function()
--     require "ultimate-autopair.core".modes = { 'i' }
--     require "ultimate-autopair".setup {}
-- end)

aSetup({ source = "jiaoshijie/undotree" }, later, "undotree", { window = { winblend = 5 } })

add { source = "Apeiros-46B/qalc.nvim", checkout = "451f082" }

add { source = "tpope/vim-fugitive" }

-- add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord" }
-- add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord-ui" }

add { source = "olimorris/codecompanion.nvim", depends = {
    "nvim-lua/plenary.nvim",
    "j-hui/fidget.nvim"
} }

vim.system({ "curl", "http://localhost:11434" }, {}, function(res)
    if res.code ~= 0 then
        return
    end

    vim.schedule(function()
        vim.g.codecompanion_adapter = "llama3.1"
        setup(later, "codecompanion", {
            strategies = {
                chat = {
                    adapter = "llama3.1"
                },
            },
            adapters = {
                ["llama3.1"] = function()
                    return require "codecompanion.adapters".extend("ollama", {
                        name = "llama3.1",
                        schema = {
                            model = {
                                default = "llama3.1:latest"
                            }
                        },
                        env = {
                            url = "http://localhost:11434",
                            api_key = "",
                        }
                    })
                end
            }
        })
    end)
end)

aSetup({ source = "patrickpichler/hovercraft.nvim" }, later, "hovercraft", {})

-- add{ source = "altermo/nelisp" }
--
