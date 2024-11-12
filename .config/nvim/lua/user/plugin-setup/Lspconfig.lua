local lspconfig = require("lspconfig")


-- local capabilities = require"cmp_nvim_lsp".default_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities = require"blink.cmp".get_lsp_capabilities(capabilities)

-- lspconfig['ast_grep'].setup{ capabilities = capabilities }
--

lspconfig["hls"].setup {
    capabilities = capabilities,
    filetypes = {"haskell"},
}

lspconfig['emmet_ls'].setup{
    capabilities = capabilities,
    filetypes = { "html" }
}

lspconfig["basedpyright"].setup{
    capabilities = capabilities
}

lspconfig['nushell'].setup{
    capabilities = capabilities
}

lspconfig["raku_navigator"].setup{
    capabilities = capabilities,
    cmd = {"raku-navigator", "--stdio"}
}

lspconfig['elixirls'].setup{
    capabilities = capabilities,
    cmd = { "/home/euro/.local/share/nvim/mason/bin/elixir-ls" }
}

lspconfig["kotlin_language_server"].setup {
    capabilities = capabilities
}


local lua_ls_library = { "/usr/share/nvim/runtime/lua/vim", "/home/euro/.local/share/nvim/site/pack/deps/opt"}

lspconfig['lua_ls'].setup{
    settings= {
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
    capabilities = capabilities
}

-- lspconfig.perlnavigator.setup{
--     cmd = {
--         "node", "/home/euro/Programs/PerlNavigator/server/out/server.js", "--stdio"
--     },
--     settings = {
--         perlnavigator = {
--             perlPath = "perl"
--         }
--     }
-- }
--

lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- lspconfig['pyright'].setup{ }

lspconfig['java_language_server'].setup {
    cmd = { "/home/euro/Programs/java-language-server/dist/lang_server_linux.sh" },
    capabilities = capabilities
}

lspconfig['ts_ls'].setup {
  capabilities = capabilities,
  --filetypes = { "typescript" },
  root_dir = function() return vim.loop.cwd() end,
}
-- lspconfig['marksman'].setup{
--     capabilities = capabilities
-- }
-- lspconfig['jedi_language_server'].setup {
  -- capabilities = capabilities
-- }
lspconfig['rust_analyzer'].setup {
  capabilities = capabilities,
}
-- lspconfig['pylsp'].setup {
--   capabilities = capabilities
-- }

lspconfig['bashls'].setup{
  capabilities = capabilities
}

lspconfig['clangd'].setup{
  capabilities = capabilities,
  filetypes = { "c", "cpp" },
}
lspconfig['html'].setup{
    capabilities = capabilities
}
lspconfig['cssls'].setup{
    capabilities = capabilities
}

lspconfig['jsonls'].setup{
    capabilities = capabilities,
    settings = {
        json = {
            schemas = require"schemastore".json.schemas(),
            validate = { enable = true }
        }
    }
}
-- lspconfig['ltex'].setup{}
lspconfig.vimls.setup{
  capabilities = capabilities,
  isNeovim = true
}
