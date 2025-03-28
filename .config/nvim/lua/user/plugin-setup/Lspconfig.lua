local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require "blink.cmp".get_lsp_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config["emmet"] = {
    cmd = { "emmet-ls", "--stdio" },
    filetypes = { "html" },
    root_dir = "."
}
vim.lsp.enable("emmet")

vim.lsp.config["basedpyright"] = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git" }
}
vim.lsp.enable "basedpyright"

local lua_ls_library = { "/usr/share/nvim/runtime/lua/vim", "/home/euro/.local/share/nvim/site/pack/deps/opt" }

vim.lsp.config["luals"] = {
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
}

vim.lsp.enable("luals")


vim.lsp.config["gopls"] = {
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
}
vim.lsp.enable "gopls"

vim.lsp.config["ts_ls"] = {
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { ".git", "node_modules" },
    filetypes = { "typescript", "javascript" }
}
vim.lsp.enable "ts_ls"

vim.lsp.config["rust_analyzer"] = {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", ".git" },
    filetypes = { "rust" }
}
vim.lsp.enable "rust_analyzer"


vim.lsp.config["bashls"] = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" }
}
vim.lsp.enable("bashls")

vim.lsp.config["clangd"] = {
    cmd = {"clangd"},
    filetypes = { "c", "cpp" },
    root_markers = { ".git", "Makefile" }
}
vim.lsp.enable "clangd"

vim.lsp.config["cssls"] = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss" },
    root_markers = { "index.html", ".git" },
    settings = {
        css = { validate = true },
        scss = { validate = true },
    }
}
vim.lsp.enable "cssls"

vim.lsp.config["jsonls"] = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filtypes = { "json" },
    root_dir = function() return vim.uv.cwd() end
}
vim.lsp.enable "jsonls"

vim.lsp.config["vimls"] = {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
        isNeovim = true,
        diagnostic = { enable = true },
        suggest = { fromVimruntime = true, fromRuntimepath = true }
    },
    root_markers = { ".git" }
}

vim.lsp.enable "vimls"
