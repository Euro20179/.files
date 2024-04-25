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

--libraries{{{
add { source = "nvim-lua/plenary.nvim" }
add { source = "nvim-tree/nvim-web-devicons" }
--}}}

-- Treesitter{{{
add {
    source = "nvim-treesitter/nvim-treesitter",
}
add { source = "nushell/tree-sitter-nu" }
add { source = "nvim-treesitter/nvim-treesitter-refactor" }

add { source = "nvim-treesitter/nvim-treesitter-textobjects" }
-- }}}

--LSP+DAP{{{
for _, name in ipairs({
    "neovim/nvim-lspconfig",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'hrsh7th/nvim-cmp',
}) do
    add { source = name }
end

add { source = "mfussenegger/nvim-dap" }
add { source = "mxsdev/nvim-dap-vscode-js" }
add { source = "rcarriga/nvim-dap-ui" }
add { source = "nvim-neotest/nvim-nio" }
--}}}

aSetup({ source = "williamboman/mason.nvim" }, later, "mason", {})

add { source = "flazz/vim-colorschemes" }
add { source = "folke/tokyonight.nvim" }
add { source = "catppuccin/nvim" }

add { source = "ThePrimeagen/harpoon", monitor = "harpoon2", checkout = "harpoon2" }

aSetup({ source = "stevearc/oil.nvim" }, now, "oil", {
    default_file_explorer = true,
    view_options = {
        show_hidden = true
    },
    columns = {
        "icons"
    }
})

add { source = "folke/which-key.nvim" }

add { source = "superhawk610/ascii-blocks.nvim" }

add { source = "nvim-neorg/neorg",
    depends = {
        "pysan3/pathlib.nvim",
        "vhyrro/luarocks.nvim",
        "nvim-neorg/lua-utils.nvim"
    }
}

aSetup({ source = "smjonas/inc-rename.nvim" }, later, "inc_rename", {})

aSetup({ source = "sindrets/diffview.nvim" }, later, "diffview", {})

add { source = "echasnovski/mini.nvim" }

later(function()
    require "mini.move".setup {
        mappings = {
            left = "mh",
            right = "ml",
            down = "mj",
            up = "mk",

            line_left = "<leader>mh",
            line_right = "<leader>ml",
            line_down = "<leader>mj",
            line_up = "<leader>mk",
        }
    }
    -- require "mini.comment".setup {}
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
    require "mini.bracketed".setup {
        treesitter = { suffix = "n", options = {} }
    }
    require "mini.operators".setup {
        exchange = {
            prefix = "yx"
        },
        multiply = {
            prefix = "yd"
        },
        replace = {
            prefix = "yr"
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
end)

add { source = "uga-rosa/ccc.nvim" }
later(function()
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
end)

-- add { source = "m4xshen/autoclose.nvim" }
-- later(function()
--     require "autoclose".setup {
--         options = {
--             pair_spaces = true
--         }
--     }
-- end)

add { source = "altermo/ultimate-autopair.nvim" }
later(function ()
    require"ultimate-autopair.core".modes = {'i'}
    require"ultimate-autopair".setup{}
end)

add { source = "Euro20179/nvim-snippets" }
setup(now, "nvim-snippets", {})

aSetup({ source = "jiaoshijie/undotree" }, later, "undotree", { window = { winblend = 5 } })

aSetup({ source = "kevinhwang91/nvim-bqf" }, later, "bqf", {
    preview = {

        winblend = 0
    }
})
-- add { source = "kevinhwang91/nvim-bqf" }
add { source = "jbyuki/quickmath.nvim" }

-- aSetup({ source = "NeogitOrg/neogit" }, later, "neogit", {})
add{ source = "tpope/vim-fugitive" }

add { source = "ThePrimeagen/refactoring.nvim" }
later(function() require("refactoring").setup() end)

aSetup({ source = "jinh0/eyeliner.nvim" }, later, "eyeliner", {
    highlight_on_key = true,
    dim = true
})

aSetup({ source = "MeanderingProgrammer/markdown.nvim" }, later, "render-markdown", {
    headings = {
        "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 ",
    },
    bullets = {
        "•", "∘", "◆", "⬦"
    }
})

add { source = "dustinblackman/oatmeal.nvim" }
setup(later, "oatmeal", {
    backend = "ollama",
    model = "gemma:latest"
})

aSetup({ source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/regedit" }, now, "regedit", {})
