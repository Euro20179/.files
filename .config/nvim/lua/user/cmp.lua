local cmp = require 'cmp'
local sk = require 'cmp.types.lsp'.CompletionItemKind
-- local luasnip = require "luasnip"

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
    Property = "",
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
            vim.snippet.expand(args.body)
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
                -- luasnip = "",
                treesitter = "",
                --nvim_lua = "[Lua]",
                --latex_symbols = "[LaTeX]",
                calc = "[=]",
                time = "%",
                dynamic = "",
                mdlink = "󰌷"
                -- emoji = "E",
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
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-a>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.complete()
            else
                fallback()
            end
        end),
        ['<c-e>'] = cmp.mapping.abort(),
        ["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<c-l>'] = cmp.mapping.confirm(),
        ["<tab>"] = cmp.mapping(function(fallback)
            local jumpable = vim.snippet.jumpable(1)
            if jumpable ~= 0 and jumpable ~= nil and jumpable ~= false then
                vim.snippet.jump(1)
            elseif vim.snippet.active() then
                vim.snippet.exit()
            else
                fallback()
            end
        end),
        ["<s-tab>"] = cmp.mapping(function(fallback)
            if vim.snippet.jumpable(-1) then
                vim.snippet.jump(-1)
            elseif vim.snippet.active() then
                vim.snippet.exit()
            else
                fallback()
            end
        end)
    }),
    sources = cmp.config.sources({
        -- { name = 'nvim_lsp_signature_help', autocomplete = false },
        { name = "snippets" },
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' }, -- For luasnip users.
        { name = 'buffer' },
        { name = 'path' },
        { name = "mdlink" },
         { name = "cmp_ai" }
        -- { name = "emoji" },
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
for _, name in ipairs({ "/", "?" }) do
    cmp.setup.cmdline(name, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'nvim_lsp_document_symbol' },
            { name = 'buffer' }
        }
    })
end

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'calc' }
    })
})
