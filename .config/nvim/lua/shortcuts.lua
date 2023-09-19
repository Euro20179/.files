vim.g.mapleader = " "

-- local moveline = require("moveline")
local utilLeader = "<A-u>"

--Normal Mode{{{
    local nShortcuts = {
        --copy shortcuts {{{
            { "<leader>p",  '"+p' },
            { "<leader>P",  '"+P' },
            { "<leader>y",  '"+y' },
            { "<leader>Y",  '"+Y' },
            { "<leader>d",  '"_d' },
            { "<leader>d",  '"_d' },
            { "<leader>c",  '"+' },
            { "<leader>b",  "\"_" },
            --}}}
            --telescope {{{
                { "<leader>e;", "<cmd>Telescope symbols<cr>" },
                { "<leader>ej", "<cmd>Telescope jumplist<cr>" },
                { "<leader>ee", "<cmd>Telescope diagnostics<cr>" },
                { "<leader>eT", "<cmd>Telescope treesitter<cr>" },
                { "<leader>et", "<cmd>Telescope tagstack<cr>" },
                { "<leader>es", "<cmd>Telescope spell_suggest<cr>" },
                { "<leader>eH", "<cmd>Telescope highlights<cr>" },
                { "<leader>eu", "<cmd>lua require('telescope').extensions.undo.undo()<cr>" },
                { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
                { "<leader>fb", '<cmd>Telescope buffers<cr>' },
                { "<leader>fe", '<cmd>Telescope find_files<cr>' },
                { "<leader>ff", ':tabnew<cr>:Telescope find_files<cr>' },
                { "<leader>fj", '<cmd>Telescope jumplist<cr>' },
                { "<leader>f/", '<cmd>Telescope live_grep<cr>' },
                { "<leader>b/", "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
                --}}}
                --Viewers {{{
                    { "<leader>n",  ":CHADopen<cr>" },
                    { "<leader>N", function()
                        require("ranger-nvim").open(true)
                    end },
                    { "<leader>o",     "<cmd>SymbolsOutline<cr>" },
                    --}}}
                    --buffer/window shortcuts{{{
                        { "<leader>S",     ':split \\| wincmd j<cr>' },
                        { "<leader>V",     ':vsplit \\| wincmd l<cr>' },
                        { "<leader>l",     ":tabnext<cr>" },
                        { "<leader>h",     ':tabprev<CR>' },
                        { "<leader><c-l>", ':bn<CR>' },
                        { "<leader><c-h>", ':bp<CR>' },
                        { "<leader>t",     ':tabnew<CR>' },
                        { "<leader>q",     ':tabclose<cr>' },
                        { "<right>",       "<c-w>>" },
                        { "<left>",        "<c-w><" },
                        { "<up>",          "<c-w>+" },
                        { "<down>",        "<c-w>-" },
                        { "<leader>vw", function()
                            vim.fn.chdir("~/Documents/vimwiki")
                            vim.api.nvim_cmd({
                                cmd = "e",
                                args = {"index.norg"}
                            })
                        end
                    },
                    --}}}
                    -- Git {{{
                        { "<leader>gl",
                        function()
                            vim.cmd [[new | wincmd j | read !git log]]
                            vim.o.filetype = "gitlog"
                            vim.api.nvim_cmd({
                                cmd = "norm",
                                args = {"gg"}
                            })
                            vim.keymap.set("n", "q", ":q<cr>", { buffer = vim.api.nvim_get_current_buf() })
                        end
                    },
                    { "<leader>gD", function()
                        require("user.telescope").telescope_diff()
                    end },
                    { "<leader>gd", "<cmd>DiffviewOpen<cr>" },
                    -- }}}
                    --emmet{{{
                        { "<leader>,",  "<c-y>," },
                        --}}}
                        --lsp {{{
                            { "<leader>fs", '<cmd>Telescope lsp_document_symbols<cr>' },
                            { "<leader>fS", '<cmd>Telescope lsp_workspace_symbols<cr>' },
                            { "<leader>fr", '<cmd>Telescope lsp_references<cr>' },
                            { "<leader>E",  "<cmd>TroubleToggle<cr>" },
                            { "<leader>r",  ":IncRename " },
                            { "<leader>el", require("lsp_lines").toggle },
                            { "<a-e>", function()
                                vim.diagnostic.open_float()
                            end
                        },
                        { "glh",       vim.lsp.buf.hover },
                        { "<leader>a", "<cmd>CodeActionMenu<cr>" },
                        { "<leader>A", function()
                            local n = 0
                            vim.lsp.buf.code_action({
                                filter = function()
                                    n = n + 1
                                    return n == 1
                                end,
                                apply = true
                            })
                        end
                    },
                    { "]d", function()
                        vim.diagnostic.goto_next()
                    end
                },
                { "]D", function()
                    vim.diagnostic.goto_next()
                    local n = 0
                    vim.lsp.buf.code_action({
                        filter = function(a)
                            n = n + 1
                            return n == 1
                        end,
                        apply = true
                    })
                end
            },
            { "[d", function()
                vim.diagnostic.goto_prev({})
            end
        },

        { "[D", function()
            vim.diagnostic.goto_prev({})
            local n = 0
            vim.lsp.buf.code_action({
                filter = function(a)
                    n = n + 1
                    return n == 1
                end,
                apply = true
            })
        end
    },
    {
        "<leader>=",
        function()
            vim.lsp.buf.format { async = true }
        end
    },
    --}}}
    -- Treesitter {{{
        { "<A-r>",           "<cmd>RegexplainerToggle<cr>" },
        { "<a-h>",           require("tree-climber").goto_parent },
        { "<a-l>",           require("tree-climber").goto_child },
        { "<leader>vn",      require("tree-climber").select_node },
        { "<a-j>",           require("tree-climber").swap_next },
        { "<a-k>",           require("tree-climber").swap_prev },
        { "glt",             ":TSHighlightCapturesUnderCursor<cr>" },
        -- }}}
        --syntax highlighting{{{
            { "<A-f>s",          ":set foldmethod=syntax<cr>" },
            { "<A-f>m",          ':set foldmethod=marker<cr>' },
            { "<C-n>",           ':noh<CR>' },
            { "<C-s>",           ':setlocal spell! spelllang=en_us<CR>' },
            { "<A-s>",           ':syntax sync fromstart<CR>' },
            --}}}
            --normal movement {{{
                { "<c-l>",           "<C-w>l" },
                { "<c-j>",           "<C-w>j" },
                { "<c-h>",           "<C-w>h" },
                { "<c-k>",           "<C-w>k" },
                --}}}
                -- Util Functions {{{
                    { utilLeader .. "W", "\"=v:lua.Rword()<cr>p" },
                    { utilLeader .. "y", function()
                        Ytfzf({
                            _on_done = function(selection)
                                local data = vim.split(selection[1], "|")
                                local url = data[#data]
                                vim.system({"mpv", url})
                                -- vim.cmd([[!mpv ]] .. "\"" .. url .. "\"")
                            end
                        })
                    end },
                    { utilLeader .. "w", "<cmd>!detex % | wc -w<cr>" },
                    { utilLeader .. "d", "<cmd>lua Fmt_date()<cr>" },
                    { utilLeader .. "n", function()
                        if vim.opt.relativenumber == true then
                            vim.opt.relativenumber = false
                        else
                            vim.opt.relativenumber = true
                        end
                    end },
                    { "<C-c>",      "<cmd>CccPick<cr>" },
                    { "<a-x>",      "<cmd>CccConvert<cr>" },
                    -- }}}
                    -- Wiki {{{
                        { "<leader>W",  "<cmd>cd ~/Documents/vimwiki/norg-home | e index.norg<cr>" },
                        { "<leader>G",  "<cmd>Glow<cr>" },
                        -- }}}
                        -- lazy {{{
                            { "<leader>Lu", "<cmd>Lazy update<cr>" },
                            { "<leader>Lx", "<cmd>Lazy clean<cr>" },
                            -- }}}
                        }
                        for _, map in ipairs(nShortcuts) do
                            vim.keymap.set("n", map[1], map[2], map[3] or {})
                        end
                        --}}}


-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>",        "<C-w>" },
    { "<C-g>$",        "<Esc>$a" },
    { "<C-g>l",        "<Esc>la" },
    { "<C-g>h",        "<Esc>ha" },
    { "<C-g>0",        "<Esc>0i" },
    { "<C-g>^",        "<Esc>^i" },
    { "<C-g>b",        "<Esc>bi" },
    { "<C-g>w",        "<Esc>wi" },
    { "<C-g>B",        "<Esc>Bi" },
    { "<C-g>W",        "<Esc>Wi" },
    { "<c-space>l",    "<Esc>:tabnext<CR>" },
    { "<c-space>h",    "<Esc>:tabprev<CR>" },
    { "<c-backspace>", "<c-w>" },
    -- }}}
    -- luasnip {{{
    { "<Tab>",
        function()
            if (require "luasnip".expand_or_jumpable()) then
                return '<Plug>luasnip-expand-or-jump'
            else
                return "<Tab>"
            end
        end,
        { expr = true, silent = true, noremap = true }
    },
    { "<S-Tab>",
        function()
            return '<cmd>lua require"luasnip".jump(-1)<cr>'
        end,
        { expr = true, silent = true }
    },
    { "<c-n>",
        function()
            if require("luasnip").choice_active() then
                return '<Plug>luasnip-next-choice'
            end
            return '<c-n>'
        end,
        { silent = true, expr = true }
    },
    { "<c-p>",
        function()
            if require "luasnip".choice_active() then
                return '<Plug>luasnip-prev-choice'
            end
            return '<c-p>'
        end,
        { silent = true, expr = true }
    },
    -- }}}
    -- Util Functions {{{
    { utilLeader .. "w", "<C-r>=v:lua.Rword()<cr>" },
    -- }}}
}
for _, map in ipairs(iShortcuts) do
    vim.keymap.set("i", map[1], map[2], map[3])
end
--}}}

--Visual Mode{{{
local vShortcuts = {
    -- copying {{{
    { "<leader>y", "\"+y" },
    { "<leader>d", "\"_d" },
    { "<leader>c", "\"_c" },
    { "<leader>p", "\"+p" },
    -- }}}
    -- indentation {{{
    { "<",         "<gv" },
    { ">",         ">gv" },
    --}}}
    --treesitter{{{
    { "<a-h>",     require("tree-climber").goto_parent },
    { "<a-l>",     require("tree-climber").goto_child },
    { "<a-j>",     require("tree-climber").goto_next },
    { "<a-k>",     require("tree-climber").goto_prev },
    --}}}
    -- chatbot{{{
    { "D",         ":ChatBotDocument<cr>" },
    { "C",         ":ChatBotComment<cr>" },
    -- }}}
    -- move code {{{
    {"<A-j>", ":m '>+1<CR>gv=gv"},
    {"<A-k>", ":m '<-2<CR>gv=gv"},
    -- }}}
}
for _, map in ipairs(vShortcuts) do
    vim.keymap.set("v", map[1], map[2])
end --}}}

-- Select Mode {{{
local sShortcuts = {
    --luasnip {{{
    { "<Tab>",   "<cmd>lua require('luasnip').jump(1)<Cr>" },
    { "<S-Tab>", "<cmd>lua require('luasnip').jump(-1)<Cr>" },
    --visual also binds this for some reason?
    { "C",       "C",                                       expr = true },
    { "D",       "D",                                       expr = true },
    --}}}
}
for _, map in ipairs(sShortcuts) do
    vim.keymap.set("s", map[1], map[2])
end --}}}

-- Terminal Mode {{{
local tShortcuts = {
    { "<leader><esc>", "<c-\\><c-n>" },
    { "<leader><C-[>", "<c-\\><c-n>" },
}
for _, map in ipairs(tShortcuts) do
    vim.keymap.set("t", map[1], map[2])
end
-- }}}

-- popup menu{{{
--here as example
vim.cmd [[
aunmenu PopUp
nnoremenu PopUp.hi :lua print("hi")<cr>
]]
--}}}
