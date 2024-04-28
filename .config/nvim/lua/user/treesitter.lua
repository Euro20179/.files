-- require'aerial'.setup{
--     filter_kind = false
-- }

-- require'nvim-highlight-colors'.setup {
--     render = "background"
-- }
--

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.nu = {
    install_info = {
        url = "https://github.com/nushell/tree-sitter-nu",
        files = { "src/parser.c" },
        branch = "main",
    },
    filetype = "nu",
}

parser_config.hypr = {
    install_info = {
        url = "https://github.com/luckasRanarison/tree-sitter-hyprlang",
        files = { "src/parser.c" },
        branch = "master",
    },
    filetype = "hypr",
}

parser_config.bircle = {
    install_info = {
        url = "/home/euro/Programs/Coding Projects/treesitter/bircle",
        files = { "src/parser.c" },
        branch = "main",
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
    },
    filetype = "bircle"
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "org" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org" }
        -- disable = function(lang, buf)
        --     -- I genuinely have no idea why this file is so laggy, but the problem has to do with require("treesitter.locals") or whatever that module is called
        --     if vim.api.nvim_buf_get_name(buf) == "/home/euro/Programs/Coding Projects/JS Things/bircle/src/commands.ts" then
        --         return true
        --     end
        --     return false
        --     -- return false
        -- end
    },
    playground = {
        enable = true,
        keybinds = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?"
        }
    },
    refactor = {
        smart_rename = {
            enable = false,
        },
        navigation = {
            enable = true,
            keymaps = {
                list_definitions = "gsD",
                goto_next_usage = "<A-n>",
                goto_previous_usage = "<A-p>",
            }
        }
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<leader>vn",
            node_incremental = 'gin',
            scope_incremental = "gis",
            node_decremental = "gip",
        }
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["<A-n>"] = "@parameter.inner",
            },
            swap_previous = {
                ["<A-p>"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
                ["]%"] = "@block.outer"
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[%"] = "@block.outer"
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ["<leader>F"] = "@function.outer",
                ["<leader>C"] = "@class.outer",
            }
        },
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["i%"] = "@block.inner",
                ["a%"] = "@block.outer",
                ["i,"] = "@parameter.inner",
                ["a,"] = "@parameter.outer",
                ["i$"] = "@call.inner",
                ["a$"] = "@call.outer",
                ["i="] = "@assignment.inner",
                ["ik"] = "@assignment.lhs",
                ["a="] = "@assignment.outer",
                ["iv"] = "@assignment.rhs",
                ["ir"] = "@regex.inner",
                ['ar'] = "@regex.outer"
            },
        },
    }
}
--
-- require'treesitter-context'.setup{
--     enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
--     max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
--     trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
--     patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
--         -- For all filetypes
--         -- Note that setting an entry here replaces all other patterns for this entry.
--         -- By setting the 'default' entry below, you can control which nodes you want to
--         -- appear in the context window.
--         default = {
--             'class',
--             'function',
--             'method',
--             'for', -- These won't appear in the context
--             'while',
--             'if',
--             'switch',
--             'case',
--         },
--         -- Example for a specific filetype.
--         -- If a pattern is missing, *open a PR* so everyone can benefit.
--         --   rust = {
--         --       'impl_item',
--         --   },
--     },
--     exact_patterns = {
--         -- Example for a specific filetype with Lua patterns
--         -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
--         -- exactly match "impl_item" only)
--         -- rust = true,
--     },
--
--     -- [!] The options below are exposed but shouldn't require your attention,
--     --     you can safely ignore them.
--
--     zindex = 20, -- The Z-index of the context window
--     mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
--     separator = '-', -- Separator between context and content. Should be a single character string, like '-'.
-- }
