vim.g.mapleader = " "

local harpoon = require "harpoon"
harpoon:setup()

local widgets = require "dap.ui.widgets"

-- local moveline = require("moveline")
local utilLeader = "<M-u>"

local gitLeader = "<M-g>"

local dapLeader = "<M-d>"

--Normal Mode{{{
local nShortcuts = {
    -- dap {{{
    { dapLeader .. "o", function()
        require "dapui".toggle()
    end, { desc = "toggle dap ui" } },
    { dapLeader .. "s", function()
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
    end, { desc = "open scopes" } },
    { dapLeader .. "f", function()
        local sidebar = widgets.sidebar(widgets.frames)
        sidebar.open()
    end, { desc = "open frames" } },
    { dapLeader .. "<leader>", function()
        require "dap".repl.toggle()
    end, { desc = "open repl" } },
    { dapLeader .. "k", function()
        widgets.hover()
    end, { desc = "hover widget" } },
    { dapLeader .. "t", function()
        local sidebar = widgets.sidebar(widgets.threads)
        sidebar.open()
    end, { desc = "open threads" } },
    { dapLeader .. "e", function()
        local sidebar = widgets.sidebar(widgets.expression)
        sidebar.open()
    end, { desc = "open expressions" } },
    { dapLeader .. "b", function() require "dap".toggle_breakpoint() end, { desc = "toggle breakpoint" } },
    { dapLeader .. "P", function() require "dap".pause() end,             { desc = "pause" } },
    { dapLeader .. "c", function() require "dap".continue() end,          { desc = "continue" } },
    { dapLeader .. "n", function() require "dap".step_over() end,         { desc = "setp over" } },
    { dapLeader .. "p", function() require "dap".step_back() end,         { desc = "step back" } },
    { dapLeader .. "i", function() require "dap".step_into() end,         { desc = "step into" } },
    { dapLeader .. "I", function() require "dap".step_out() end,          { desc = "step out" } },
    { dapLeader .. "r", function()
        require "dap".session()
        require "dap".continue()
    end, { desc = "start session" } },
    -- }}}
    --copy shortcuts {{{
    { "<leader>p",  '"+p',                                { desc = "paste from sys clipboard" } },
    { "<leader>P",  '"+P',                                { desc = "paste above from sys clipboard" } },
    { "<leader>y",  '"+y',                                { desc = "copy to sys clipboard" } },
    { "<leader>Y",  '"+Y',                                { desc = "copy line to sys clipboard" } },
    { "<leader>d",  '"_d',                                { desc = "delete to null register" } },
    { "<leader>c",  '"_c',                                { desc = "change to null register" } },
    { "<leader>b",  "\"_",                                { desc = "run on null register" } },
    { "<leader>B",  "\"+",                                { desc = "run on sys clipboard" } },
    --}}}
    --telescope {{{
    { "<leader>e;", "<cmd>Telescope symbols<cr>",         { desc = "emojis" } },
    { "<leader>ej", "<cmd>Telescope jumplist<cr>",        { desc = "jumplist" } },
    { "<leader>ee", "<cmd>Telescope diagnostics<cr>",     { desc = "diagnostics" } },
    { "<leader>eT", "<cmd>Telescope treesitter<cr>",      { desc = "treesitter" } },
    { "<leader>et", "<cmd>Telescope tagstack<cr>",        { desc = "tagstack" } },
    { "<leader>es", "<cmd>Telescope spell_suggest<cr>",   { desc = "spell suggest" } },
    { "<leader>eH", "<cmd>Telescope highlights<cr>",      { desc = "highlights" } },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",       { desc = "help tags" } },
    { "<leader>fb", '<cmd>Telescope buffers<cr>',         { desc = "buffers" } },
    { "<leader>ec", "<cmd>Telescope colorscheme<cr>",     { desc = "colorscheme" }},
    { "<leader>fE", ':bdel<cr>:Telescope find_files<cr>', { desc = "find files (delete current buffer)" } },
    { "<leader>fe", ':Telescope find_files<cr>',          { desc = "find files" } },
    { "<leader>fq", ":Telescope quickfix<cr>",            { desc = "quickfix list" } },
    { "<leader>ff", function()
        local t = require "telescope.builtin"
        harpoon:list():append()
        t.find_files({ hidden = true })
    end, { desc = "open file and save current buffer in harpoon" } },
    { "<leader>fF", function()
        local t = require "telescope.builtin"
        harpoon:list():append()
        t.find_files({ hidden = true, no_ignore = true })
    end, { desc = "open any file, save current buffer in harpoon" } },
    { "<leader>fj", '<cmd>Telescope jumplist<cr>',                               { desc = "jumplist" } },
    { "<leader>f/", '<cmd>Telescope live_grep<cr>',                              { desc = "grep" } },
    { "<leader>fm", "<cmd>Telescope marks<cr>",                                  { desc = "marks" } },
    { "<leader>b/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",              { desc = "buffer fuzzy find" } },
    { "<leader>fH", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon menu" } },
    --}}}
    --Viewers {{{
    { "<leader>eu", "<cmd>lua require('undotree').toggle()<cr>" },
    { "<leader>n",  ":Neotree float<cr>" },
    { "<leader>z", "<cmd>Yazi<cr>" },
    { "gO", function()
        if vim.g._outline_cmd then
            vim.cmd(vim.g._outline_cmd)
        else
            --fallback
            vim.cmd [[SymbolsOutline]]
        end
    end },
    --}}}
    --buffer/window shortcuts{{{
    { "<leader><leader>", function() harpoon:list():append() end },
    { "<leader>1",        function() harpoon:list():select(1) end },
    { "<leader>2",        function() harpoon:list():select(2) end },
    { "<leader>3",        function() harpoon:list():select(3) end },
    { "<leader>4",        function() harpoon:list():select(4) end },
    { "<leader>5",        function() harpoon:list():select(5) end },
    { "<leader>6",        function() harpoon:list():select(6) end },
    { "<leader>7",        function() harpoon:list():select(7) end },
    { "<leader>8",        function() harpoon:list():select(8) end },
    { "<leader>9",        function() harpoon:list():select(9) end },
    { "<leader>S",        ':split | wincmd j<cr>' },
    { "<leader>V",        ':vsplit | wincmd l<cr>' },
    { "<leader>l",        ":tabnext<cr>" },
    { "<leader>h",        ':tabprev<CR>' },
    { "<leader><c-l>",    ':bn<CR>' },
    { "<leader><c-h>",    ':bp<CR>' },
    { "<leader>t",        ':tabnew<CR>' },
    { "<leader>q",        ':tabclose<cr>' },
    { "<right>",          "<c-w>>" },
    { "<left>",           "<c-w><" },
    { "<up>",             "<c-w>+" },
    { "<down>",           "<c-w>-" },
    { "<leader>T",        function() GotoTerminalBuf() end },
    { "<leader>ft", function()
        require "lazy.util".float_term("/bin/zsh", {
            border = "single"
        })
    end },
    { "<leader>vw", function()
        vim.fn.chdir("~/Documents/vimwiki")
        vim.api.nvim_cmd({
            cmd = "e",
            args = { "index.norg" }
        }, {})
    end
    },
    --}}}
    -- Git {{{
    { gitLeader .. "l",
        function()
            local neogit = require("neogit")
            neogit.open({ "log" })
        end
    },
    { gitLeader .. "c", function()
        require "neogit".open({ "commit" })
    end },
    { gitLeader .. "D", function()
        require("user.telescope").telescope_diff()
    end },
    { gitLeader .. "d",       "<cmd>DiffviewOpen<cr>" },
    { gitLeader .. gitLeader, "<cmd>Gitsigns toggle_deleted<cr>" },
    { gitLeader .. "p", function()
        require "neogit".open({ "push" })
    end },
    -- }}}
    --emmet{{{
    { "<leader>,",  "<c-y>," },
    --}}}
    --lsp {{{
    { "<leader>fs", '<cmd>Telescope lsp_document_symbols<cr>' },
    { "gns", vim.lsp.buf.document_symbol },
    { "gnw", vim.lsp.buf.workspace_symbol },
    { "<leader>fS", '<cmd>Telescope lsp_workspace_symbols<cr>' },
    { "<leader>fr", '<cmd>Telescope lsp_references<cr>' },
    { "<leader>E",  function ()
        vim.fn.setqflist(vim.diagnostic.get())
        vim.cmd.cwindow()
    end},
    { "<leader>r",  ":IncRename " },
    { "<leader>el", function()
        local virt_text = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not virt_text })
    end },
    { "<a-e>", function()
        vim.diagnostic.open_float()
    end
    },
    --{ "glh",       vim.lsp.buf.hover }, commenting out to force myself to use K
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
    { "]D", function()
        vim.diagnostic.goto_next()
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
    { "<leader>K", function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end,
        { desc = "Toggle inlay hints" } },
    { "<leader>k", vim.lsp.buf.signature_help,                                      { desc = "Show function signature" } },
    { "gK",        vim.diagnostic.open_float,                                       { desc = "Open diagnostic float" } },
    { "g<c-]>",    function() vim.lsp.buf.type_definition({ reuse_win = true }) end },
    { "[D", function()
        vim.diagnostic.goto_prev({})
        local n = 0
        vim.lsp.buf.code_action({
            filter = function(_)
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
    { "<leader>sr",      function() require "ssr".open() end },
    { "<A-r>",           "<cmd>RegexplainerToggle<cr>" },
    { "<a-t>p",           require("tree-climber").goto_parent },
    { "<a-t>c",           require("tree-climber").goto_child },
    { "<a-t>n",           require"tree-climber".goto_next},
    { "<a-t>p",           require"tree-climber".goto_prev},
    { "<leader>vn",      require("tree-climber").select_node },
    { "<a-j>",           require("tree-climber").swap_next },
    { "<a-k>",           require("tree-climber").swap_prev },
    { "glt",             "<cmd>Inspect<cr>" },
    -- }}}
    --syntax highlighting{{{
    { "<A-f>s",          ":set foldmethod=syntax<cr>" },
    { "<A-f>m",          ':set foldmethod=marker<cr>' },
    { "<A-f>e",          ':set foldmethod=expr<cr>' },
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
    { utilLeader .. "e", ":Neorg exec cursor<CR>" },
    { utilLeader .. "W", "\"=v:lua.Rword()<cr>p" },
    { utilLeader .. "y", function()
        Ytfzf({
            _on_done = function(selection)
                local data = vim.split(selection[1], "|")
                local url = data[#data]
                vim.system({ "mpv", url })
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
    {"ZF", require"mini.misc".zoom},
    {"<c-q>", vim.cmd.cwindow},
    {"<leader>/", ":silent grep! | cwindow<S-Left><S-Left>"}
}
for _, map in ipairs(nShortcuts) do
    vim.keymap.set("n", map[1], map[2], map[3] or {})
end
--}}}

-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>",          "<C-w>" },
    { "<C-g>$",          "<Esc>$a" },
    { "<C-g>l",          "<Esc>la" },
    { "<C-g>h",          "<Esc>ha" },
    { "<C-g>0",          "<Esc>0i" },
    { "<C-g>^",          "<Esc>^i" },
    { "<C-g>b",          "<Esc>bi" },
    { "<C-g>w",          "<Esc>wi" },
    { "<C-g>B",          "<Esc>Bi" },
    { "<C-g>W",          "<Esc>Wi" },
    { "<c-space>l",      "<Esc>:tabnext<CR>" },
    { "<c-space>h",      "<Esc>:tabprev<CR>" },
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
    { "<c-l>",           "<C-w>l" },
    { "<c-j>",           "<C-w>j" },
    { "<c-h>",           "<C-w>h" },
    { "<c-k>",           "<C-w>k" },
    { utilLeader .. "e", ":Exec<CR>" },
    -- copying {{{
    { "<leader>y",       "\"+y" },
    { "<leader>d",       "\"_d" },
    { "<leader>c",       "\"_c" },
    { "<leader>p",       "\"+p" },
    -- }}}
    -- indentation {{{
    { "<",               "<gv" },
    { ">",               ">gv" },
    --}}}
    --treesitter{{{
    { "<leader>sr",      function() require "ssr".open() end },
    { "<a-h>",           require("tree-climber").goto_parent },
    { "<a-l>",           require("tree-climber").goto_child },
    { "<a-j>",           require("tree-climber").goto_next },
    { "<a-k>",           require("tree-climber").goto_prev },
    --}}}
    -- chatbot{{{
    { "DD",               ":ODocument<cr>" },
    { "DC",               ":ChatBotComment<cr>" },
    { "C", function ()
        vim.api.nvim_feedkeys(":M complete\r", "n", true)
    end},
    -- }}}
    -- move code {{{
    { "mj",              ":m '>+1<CR>gv=gv" },
    { "mk",              ":m '<-2<CR>gv=gv" },
    { "<leader>r", function()
        require("sniprun").run("v")
    end }
    -- }}}
}
for _, map in ipairs(vShortcuts) do
    vim.keymap.set("v", map[1], map[2])
end --}}}

-- Select Mode {{{
local sShortcuts = {
    --luasnip {{{
    { "<Tab>",   "<cmd>lua vim.snippet.jump(1)<Cr>" },
    { "<S-Tab>", "<cmd>lua vim.snippet.jump(-1)<Cr>" },
    --visual also binds this for some reason?
    { "C",       "C",                                expr = true },
    { "D",       "D",                                expr = true },
    --}}}
}
for _, map in ipairs(sShortcuts) do
    vim.keymap.set("s", map[1], map[2])
end --}}}

-- Terminal Mode {{{
local tShortcuts = {
    { "<F4>",         "<c-\\><c-n>" },
    { "<c-\\><c-\\>", "<c-\\><c-n>" }
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

vim.keymap.set("o", "O", "<esc>mzkddg`z")         --motion to delete above line
vim.keymap.set("o", "o", "<esc>mzjddg`z")         --motion to delete below line
vim.keymap.set("n", "dal", "<esc>mzkddg`zjddg`z") -- delete around line

vim.keymap.set({ "o", "x" }, "gC", function()
    require "various-textobjs".multiCommentedLines()
end)

vim.keymap.set({ "o", "x" }, "?", function()
    require "various-textobjs".diagnostic()
end)

-- local surround_prefix = "s"
-- local surround_chars = { "{", "[", "(", "'", '"', "<", "}", "]", ")" }
-- local surround = require "visual-surround".surround
-- for _, key in pairs(surround_chars) do
--     vim.keymap.set("v", surround_prefix .. key, function()
--         surround(key)
--     end, { desc = "[visual-surround] " .. key })
-- end
