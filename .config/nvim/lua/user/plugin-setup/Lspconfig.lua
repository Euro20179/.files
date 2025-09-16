local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require "blink.cmp".get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

---Setup an lsp server
---@param name string
---@param settings vim.lsp.Config
local function setupLSP(name, settings)
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

setupLSP("html", {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "tmpl" },
    root_markers = { "package.json", ".git" },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" }
    }
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
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact"  },
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

setupLSP("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filtypes = { "json" },
    root_dir = function() return vim.uv.cwd() end
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
