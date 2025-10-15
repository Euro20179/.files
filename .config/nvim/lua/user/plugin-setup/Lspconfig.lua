local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require "blink.cmp".get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

---Setup an lsp server
---@param name string
---@param settings vim.lsp.Config
local function setupLSP(name, settings)
    -- local kind2name = {
    --      [ 1 ] = "Text",
    --      [ 2 ] = "Method",
    --      [ 3 ] = "Function",
    --      [ 4 ] = "Constructor",
    --      [ 5 ] = "Field",
    --      [ 6 ] = "Variable",
    --      [ 7 ] = "Class",
    --      [ 8 ] = "Interface",
    --      [ 9 ] = "Module",
    --      [ 10 ] = "Property",
    --      [ 11 ] = "Unit",
    --      [ 12 ] = "Value",
    --      [ 13 ] = "Enum",
    --      [ 14 ] = "Keyword",
    --      [ 15 ] = "Snippet",
    --      [ 16 ] = "Color",
    --      [ 17 ] = "File",
    --      [ 18 ] = "Reference",
    --      [ 19 ] = "Folder",
    --      [ 20 ] = "EnumMember",
    --      [ 21 ] = "Constant",
    --      [ 22 ] = "Struct",
    --      [ 23 ] = "Event",
    --      [ 24 ] = "Operator",
    --      [ 25 ] = "TypeParameter",
    -- }
    --
    -- local kind_icons = {
    --     Text = "",
    --     Method = " ",
    --     Function = "",
    --     Constructor = "",
    --     Field = "",
    --     Variable = "𝑥",
    --     Class = "",
    --     Interface = "",
    --     Module = "",
    --     Property = "",
    --     Unit = "",
    --     Value = "",
    --     Enum = "",
    --     Keyword = "",
    --     Snippet = "󱄽",
    --     Color = "",
    --     File = "",
    --     Reference = "",
    --     Folder = "",
    --     EnumMember = "",
    --     Constant = "",
    --     Struct = "",
    --     Event = "",
    --     Operator = "",
    --     TypeParameter = ""
    -- }
    --
    -- settings.on_attach = function(client, buf)
    --     vim.cmd[[set completeopt+=menuone,noselect,popup]]
    --     vim.cmd[[inoremap <c-n> <c-x><c-o>]]
    --     vim.lsp.completion.enable(true, client.id, buf, {
    --         autotrigger = true,
    --         convert = function(item)
    --             return {
    --                 abbr = item.label,
    --                 kind = kind_icons[kind2name[item.kind]],
    --                 abbr_hlgroup = kind_icons[kind2name[item.kind]]
    --             }
    --         end
    --     })
    -- end
    vim.lsp.config[name] = settings
    vim.lsp.enable(name)
end

vim.lsp.config("*", { capabilities = capabilities })

setupLSP("raku", {
    cmd = { "raku-navigator", "--stdio" },
    filetypes = { "raku" },
    root_dir = "."
})

setupLSP("zig", {
    cmd = { "zls" },
    filetypes = { "zig" },
    root_dir = "."
})

setupLSP("emmet", {
    cmd = { "emmet-ls", "--stdio" },
    filetypes = { "html", "css" },
    root_dir = "."
})

setupLSP("phpactor", {
    cmd = { "phpactor", "language-server", "-vvv" },
    filetypes = { "php" },
    root_dir = vim.uv.cwd()
})

setupLSP("basedpyright", {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git" },
    settings = {
        basedpyright = {
            analysis = {
                inlayHints = {
                    callArgumentNames = true
                }
            }
        }
    }
})

local lua_ls_library = { "/usr/share/nvim/runtime/lua/vim", "/home/euro/.local/share/nvim/site/pack/deps/opt" }

setupLSP("luals", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
        Lua = {
            hint = { enable = true },
            completion = {
                callSnippet = "Replace"
            },
            telemetry = {
                enable = false
            },
            workspace = {
                checkThirdParty = false,
                library = lua_ls_library
            }
        },
    },
})



setupLSP("gopls", {
    cmd = { "gopls", "serve" },
    filetypes = { "go" },
    root_markers = { "go.mod", ".git" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        }
    }
})

local TS_LS_SETTINGS = {
    inlayHints = {
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = true
    },
}


setupLSP("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { ".git", "node_modules" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    settings = {
        javascript = TS_LS_SETTINGS,
        typescript = TS_LS_SETTINGS
    }
})

setupLSP("rust_analyzer", {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", ".git" },
    filetypes = { "rust" }
})


setupLSP("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" }
})

setupLSP("clangd", {
    cmd = { "clangd", "--fallback-style=webkit" },
    filetypes = { "c", "cpp" },
    root_markers = { ".git", "Makefile" }
})

setupLSP("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    init_options = { provideFormatter = true },
    filetypes = { "css", "scss" },
    root_markers = { "index.html", ".git" },
    settings = {
        css = { validate = true },
        scss = { validate = true },
    }
})


setupLSP("vimls", {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
        isNeovim = true,
        diagnostic = { enable = true },
        suggest = { fromVimruntime = true, fromRuntimepath = true }
    },
    root_markers = { ".git" }
})
