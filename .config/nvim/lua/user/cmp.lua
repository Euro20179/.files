local cmp = require 'cmp'

local kind_icons = {
    Text = "",
    Method = " ",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "𝑥",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
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
}

cmp.setup({
    experimental = {
        ghost_text = true
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
            vim_item.menu = ({
                    --buffer = "-",
                    nvim_lsp = "*",
                    spell = "S",
                    luasnip = "",
                    treesitter = "",
                    --nvim_lua = "[Lua]",
                    --latex_symbols = "[LaTeX]",
                    calc = "[=]",
                    time = "%",
                    dynamic = ""
                    --emoji = "[Emoji]",
                    --rg = '[/]',
                    --look = '[Look]',
                    --digraphs = '[Digraph]',
                    --browser = '[🌎]',
                })[entry.source.name]
            return vim_item
        end
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-s>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm()
    }),
    sources = cmp.config.sources({
        -- { name = 'nvim_lsp_signature_help', autocomplete = false },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'buffer' },
        { name = 'path' },
        { name = "spell" },
        -- { name = "time" },
        --{
        --name = "dictionary",
        --keyword_length = 2
        --},
        --{ name = 'browser' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'nvim_lsp_document_symbol' },
        { name = 'buffer' }
    }
})


-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'calc' }
    })
})
