local lspconfig = require("lspconfig")

local on_attach = function (client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        require"nvim-navic".attach(client, bufnr)
    end
end


local capabilities = require('cmp_nvim_lsp').default_capabilities()--(vim.lsp.protocol.make_client_capabilities())

require("neodev").setup({})
lspconfig['lua_ls'].setup{
    settings= {
        Lua = {
            completion = {
                callSnippet = "Replace"
            },
            runtime = {
                version = "luaJIT"
            },
            diagnostics = {
                globals = {"vim"}
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
                enable = false
            }
        },
    },
    on_attach = on_attach
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

lspconfig.gopls.setup{}

lspconfig['pyright'].setup{
    on_attach = on_attach
}

lspconfig['java_language_server'].setup {
    cmd = { "/home/euro/Programs/java-language-server/dist/lang_server_linux.sh" },
    capabilities = capabilities
}

lspconfig['tsserver'].setup {
  capabilities = capabilities,
  --filetypes = { "typescript" },
  root_dir = function() return vim.loop.cwd() end,
  on_attach = on_attach
}
lspconfig['marksman'].setup{
    capabilities = capabilities
}
-- lspconfig['jedi_language_server'].setup {
--   capabilities = capabilities
-- }
lspconfig['rust_analyzer'].setup {
  capabilities = capabilities,
  on_attach = on_attach
}
-- lspconfig['pylsp'].setup {
--   capabilities = capabilities
-- }

lspconfig['bashls'].setup{
  on_attach = on_attach
}

lspconfig['clangd'].setup{
  capabilities = capabilities,
  filetypes = { "c", "cpp" },
  on_attach = on_attach
}
lspconfig['html'].setup{
    capabilities = capabilities
}
lspconfig['cssls'].setup{
    capabilities = capabilities
}
lspconfig['ltex'].setup{}
lspconfig.vimls.setup{
  capabilities = capabilities,
  isNeovim = true
}
