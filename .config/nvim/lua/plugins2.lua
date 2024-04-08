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

--libraries{{{
add {
    source = "nvim-lua/plenary.nvim"
}
add { source = "nvim-tree/nvim-web-devicons" }
--}}}

-- Treesitter{{{
add {
    source = "nvim-treesitter/nvim-treesitter",
}
add {
    source = "nushell/tree-sitter-nu"
}
add {
    source = "drybalka/tree-climber.nvim"
}
add { source = "https://github.com/nvim-treesitter/nvim-treesitter-refactor" }

add { source = "nvim-treesitter/nvim-treesitter-textobjects" }
-- }}}

-- Telescope{{{
add {
    source = "nvim-telescope/telescope.nvim"
}
add {
    source = "nvim-telescope/telescope-ui-select.nvim"
}
add {
    source = "nvim-telescope/telescope-symbols.nvim"
}

now(function()
    local tele = require "telescope"
    tele.setup {
        extensions = {
            ["ui-select"] = {
                require "telescope.themes".get_dropdown {}
            }
        }
    }
    tele.load_extension("ui-select")
end) -- }}}

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

add { source = "williamboman/mason.nvim" }
setup(later, "mason", {})

add { source = "bluz71/vim-nightfly-guicolors" }
add { source = "flazz/vim-colorschemes" }
add { source = "folke/tokyonight.nvim" }
add { source = "catppuccin/nvim" }

add { source = "ThePrimeagen/harpoon", monitor = "harpoon2", checkout = "harpoon2" }

add { source = "stevearc/oil.nvim" }

setup(now, "oil", {
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
add { source = "nvim-neorg/neorg-telescope" }
add { source = "laher/neorg-exec" }

add { source = "smjonas/inc-rename.nvim" }
later(function()
    require "inc_rename".setup {}
end)

add { source = "sindrets/diffview.nvim" }
later(function() require "diffview".setup {} end)

add { source = "echasnovski/mini.nvim" }

later(function()
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

add { source = "simrat39/symbols-outline.nvim" }
later(function()
    require "symbols-outline".setup {
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
end)
--
-- add { source = "m4xshen/autoclose.nvim" }
-- later(function()
--     require "autoclose".setup {
--         options = {
--             pair_spaces = true
--         }
--     }
-- end)

add { source = "altermo/ultimate-autopair.nvim" }
setup(later, "ultimate-autopair", {})

add { source = "file:///home/euro/Programs/GithubContribs/nvim-snippets" }
setup(now, "nvim-snippets", {})

add { source = "jiaoshijie/undotree" }
later(function() require "undotree".setup { window = { winblend = 5 } } end)

add { source = "kevinhwang91/nvim-bqf" }
add { source = "jbyuki/quickmath.nvim" }

add { source = "NeogitOrg/neogit" }
later(require "neogit".setup)

add { source = "chrisgrieser/nvim-various-textobjs" }
later(function()
    require "various-textobjs".setup {
        useDefaultKeymaps = true,
        disabledKeymaps = { "ik", "ak", "iv", "av", "!", "gc", "Q"}
    }
end)

add { source = "ThePrimeagen/refactoring.nvim" }
later(function()
    require("refactoring").setup()
end)

add { source = "jinh0/eyeliner.nvim" }
later(function()
    require "eyeliner".setup {
        highlight_on_key = true,
        dim = true
    }
end)

add { source = "MeanderingProgrammer/markdown.nvim" }
setup(later, "render-markdown", {
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
    model = "dolphin-mistral:latest"
})
