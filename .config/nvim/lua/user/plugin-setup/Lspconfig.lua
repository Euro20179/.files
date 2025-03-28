local lspconfig = require("lspconfig")


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require "blink.cmp".get_lsp_capabilities(capabilities)

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

lspconfig['rust_analyzer'].setup {
    capabilities = capabilities,
}
-- lspconfig['pylsp'].setup {
--   capabilities = capabilities
-- }

-- lspconfig['bashls'].setup {
--     capabilities = capabilities
-- }

vim.lsp.config["bashls"] = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" }
}
vim.lsp.enable("bashls")

lspconfig['clangd'].setup {
    capabilities = capabilities,
    filetypes = { "c", "cpp" },
}
-- lspconfig['html'].setup {
--     capabilities = capabilities
-- }
lspconfig['cssls'].setup {
    capabilities = capabilities
}

lspconfig['jsonls'].setup {
    capabilities = capabilities,
    settings = {
        json = {
            schemas = require "schemastore".json.schemas(),
            validate = { enable = true }
        }
    }
}
-- lspconfig['ltex'].setup{}
lspconfig.vimls.setup {
    capabilities = capabilities,
    isNeovim = true
}
