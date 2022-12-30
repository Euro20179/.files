local lspconfig = require("lspconfig")

local luadev = require("neodev").setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()--(vim.lsp.protocol.make_client_capabilities())

lspconfig.sumneko_lua.setup({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

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

lspconfig['java_language_server'].setup {
    cmd = { "/home/euro/Programs/java-language-server/dist/lang_server_linux.sh" },
    capabilities = capabilities
}

lspconfig['tsserver'].setup {
  capabilities = capabilities,
  --filetypes = { "typescript" },
  root_dir = function() return vim.loop.cwd() end,
  -- on_attach = function (client, bufnr)
  --   require("nvim-navic").attach(client, bufnr)
  -- end
}
lspconfig['marksman'].setup{
    capabilities = capabilities
}
-- lspconfig['jedi_language_server'].setup {
--   capabilities = capabilities
-- }
lspconfig['rust_analyzer'].setup {
  capabilities = capabilities
}
lspconfig['pylsp'].setup {
  capabilities = capabilities
}

lspconfig['bashls'].setup{}

lspconfig['clangd'].setup{
  capabilities = capabilities,
  filetypes = { "c", "cpp" }
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
