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

vim.cmd[[packadd cfilter]]

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
add { source = "MunifTanjim/nui.nvim" }
--}}}

-- Treesitter{{{
add {
    source = "nvim-treesitter/nvim-treesitter",
}

add { source = "nvim-treesitter/nvim-treesitter-textobjects" }
-- }}}

--LSP+DAP{{{

add { source = "b0o/Schemastore.nvim" }

add { source = "neovim/nvim-lspconfig" }

aSetup({ source = "icholy/lsplinks.nvim" }, later, "lsplinks", {})

local function buildBlink()
    local blink_cmp_path = vim.fn.expand("$XDG_DATA_HOME/.local/share/nvim/site/pack/deps/opt/blink.cmp")
    vim.system({ "cargo", "build", "--release", "--manifest-path", blink_cmp_path .. "/Cargo.toml" }, {},
        function(res)
            vim.schedule(function()
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
        depends = { 'rafamadriz/friendly-snippets' },
        hooks = {
            post_checkout = buildBlink,
            post_install = buildBlink,
        }
    }, later,
    "blink-cmp", {
        highlight = {
            ns = vim.api.nvim_create_namespace("blink_cmp"),
            use_nvim_cmp_as_default = true
        },
        keymap = {
            [ "<c-s>" ] = { "show", "hide" },
            [ "<c-l>" ] = { "accept" },
            [ "<c-n>" ] = { "select_next" }, 
            [ "<c-p>" ] = { "select_prev" },
            [ "<C-u>" ] = { "scroll_documentation_up" },
            [ "<C-d>" ] = { "scroll_documentation_down" },
            [ "<c-,>" ] = { "show_documentation", "hide_documentation" },
        },
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

        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer" }
            },
        },
        trigger = {
            completion = {
                keyword_regex = "[%w#_\\-]"
            }
        },
        windows = {
            autocomplete = {
                border = 'rounded',
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
            },
            ghost_text = {
                enabled = true
            }
        }
    })

add { source = "mfussenegger/nvim-dap" }
-- add { source = "mxsdev/nvim-dap-vscode-js" }
aSetup({ source = "rcarriga/nvim-dap-ui" }, later, "dapui", {})
add { source = "nvim-neotest/nvim-nio" }

aSetup({ source = "williamboman/mason.nvim" }, later, "mason", {})
--}}}


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
        yy = "actions.yank_entry",
        yc = function()
            local dir = require "oil".get_current_dir()
            vim.fn.setreg("\"", dir)
        end
    }
})

add { source = "folke/which-key.nvim" }

add { source = "nvim-neorg/neorg",
    depends = {
        "pysan3/pathlib.nvim",
        "vhyrro/luarocks.nvim",
        "nvim-neorg/lua-utils.nvim"
    }
}

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

add { source = "altermo/ultimate-autopair.nvim" }
later(function()
    require "ultimate-autopair.core".modes = { 'i' }
    require "ultimate-autopair".setup {}
end)

aSetup({ source = "jiaoshijie/undotree" }, later, "undotree", { window = { winblend = 5 } })

aSetup({ source = "kevinhwang91/nvim-bqf" }, later, "bqf", {
    preview = {
        winblend = 0
    }
})

add { source = "Apeiros-46B/qalc.nvim", checkout = "451f082" }

add { source = "tpope/vim-fugitive" }

aSetup({ source = "jinh0/eyeliner.nvim" }, later, "eyeliner", {
    highlight_on_key = true,
    dim = true
})

add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord" }
add { source = "file:///home/euro/Programs/Coding Projects/neovim-plugins/discord-ui" }

aSetup({ source = "nvim-zh/colorful-winsep.nvim" }, later, "colorful-winsep", {
    hi = {
        fg = "#f4b8e4"
    }
})

vim.system({ "curl", "http://localhost:11434" }, {}, function(res)
    if res.code ~= 0 then
        return
    end
    vim.schedule(function()
        aSetup({ source = "meeehdi-dev/bropilot.nvim", depends = { "j-hui/fidget.nvim" } }, later, "bropilot",
            {
                model = "qwen2.5-coder:1.5b-base",
                prompt = { prefix = "<|fim_prefix|>", suffix = "<|fim_suffix|>", middle = "<|fim_middle|>", },
                model_params = {
                    stop = { "<|fim_pad|>", "<|endoftext|>" },
                    num_ctx = 8192,
                },
                debounce = 500,
                auto_pull = true,
                auto_suggest = false,
                keymap = {
                    suggest = "<C-'>",
                    accept_block = "<C-Enter>",
                    accept_line = "<S-Enter>"
                }
            }
        )
    end)
end)

aSetup({ source = "patrickpichler/hovercraft.nvim" }, later, "hovercraft", {})
