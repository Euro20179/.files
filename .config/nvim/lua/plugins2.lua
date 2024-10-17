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
-- add { source = "mxsdev/nvim-dap-vscode-js" }
aSetup({ source = "rcarriga/nvim-dap-ui" }, later, "dapui", {})
add { source = "nvim-neotest/nvim-nio" }
--}}}

aSetup({ source = "williamboman/mason.nvim" }, later, "mason", {})

add { source = "flazz/vim-colorschemes" }
add { source = "folke/tokyonight.nvim" }
add { source = "catppuccin/nvim" }

add { source = "theprimeagen/harpoon", monitor = "harpoon2", checkout = "harpoon2" }

-- aSetup({ source = "JonasLeonhard/broil", depends = { {
--     source = "nvim-telescope/telescope-fzf-native.nvim",
--     pre_install = "make",
--     pre_checkout = "make"
-- }} }, now, "broil", {})

aSetup({ source = "stevearc/oil.nvim" }, now, "oil", {
    default_file_explorer = true,
    view_options = {
        show_hidden = true
    },
    columns = {
        "icon",
        "permissions"
    },
    keymaps = {
        ["yy"] = "actions.yank_entry"
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

-- aSetup({ source = "sindrets/diffview.nvim" }, later, "diffview", {})

add { source = "echasnovski/mini.nvim" }

later(function()
    -- require "mini.comment".setup {}
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

add { source = "https://github.com/NvChad/minty", depends = { "nvchad/volt" } }

add { source = "altermo/ultimate-autopair.nvim" }
later(function()
    require "ultimate-autopair.core".modes = { 'i' }
    require "ultimate-autopair".setup {}
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
-- add { source = "jbyuki/quickmath.nvim" }
add { source = "Apeiros-46B/qalc.nvim", checkout = "451f082" }

-- aSetup({ source = "NeogitOrg/neogit" }, later, "neogit", {})
add { source = "tpope/vim-fugitive" }

add { source = "ThePrimeagen/refactoring.nvim" }
later(function() require("refactoring").setup() end)

aSetup({ source = "jinh0/eyeliner.nvim" }, later, "eyeliner", {
    highlight_on_key = true,
    dim = true
})

aSetup({ source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/regedit" }, now, "regedit", {})
add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord" }
add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord-ui" }

-- aSetup({ source = "huggingface/llm.nvim" }, later, "llm", {
--     backend = "ollama",
--     model = "llama3:latest",
--     url = "http://localhost:11434/api/generate",
-- })

add { source = "fynnfluegge/monet.nvim" }

-- add { source = "rcarriga/nvim-notify" }

aSetup({ source = "nvim-zh/colorful-winsep.nvim" }, later, "colorful-winsep", {
    hi = {
        fg = "#f4b8e4"
    }
})

add { source = "vim-scripts/vis" }

aSetup({ source = "meeehdi-dev/bropilot.nvim", depends = { "j-hui/fidget.nvim" } }, later, "bropilot",
    {
        model = "qwen2.5-coder:1.5b-base",
        prompt = { prefix = "<|fim_prefix|>", suffix = "<|fim_suffix|>", middle = "<|fim_middle|>", },
        model_params = {
            stop = { "<|fim_pad|>", "<|endoftext|>" },
            num_ctx = 8192,
        },
        debounce = 100,
        auto_pull = true,
        auto_suggest = false,
        keymap = {
            suggest = "<C-'>",
            accept_block = "<C-Enter>",
            accept_line = "<S-Enter>"
        }
    }
)

aSetup({ source = "magicalne/nvim.ai" }, now, "ai", {
    provider = "ollama",
    ollama = {
        model = "llama3.1:latest"
    }
})

add { source = "MunifTanjim/nui.nvim" }

aSetup({ source = "jake-stewart/multicursor.nvim" }, later, "multicursor-nvim", {})

aSetup({ source = "https://github.com/patrickpichler/hovercraft.nvim" }, later, "hovercraft", {})

aSetup({ source = "https://github.com/Bekaboo/dropbar.nvim" }, later, "dropbar", {})
