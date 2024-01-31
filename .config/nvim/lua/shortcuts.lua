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
    end, { desc = "[DAP] toggle dap ui" } },
    { dapLeader .. "s", function()
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
    end, { desc = "[DAP] open scopes" } },
    { dapLeader .. "f", function()
        local sidebar = widgets.sidebar(widgets.frames)
        sidebar.open()
    end, { desc = "[DAP] open frames" } },
    { dapLeader .. "<leader>", function()
        require "dap".repl.toggle()
    end, { desc = "[DAP] open repl" } },
    { dapLeader .. "k", function()
        widgets.hover()
    end, { desc = "[DAP] hover widget" } },
    { dapLeader .. "t", function()
        local sidebar = widgets.sidebar(widgets.threads)
        sidebar.open()
    end, { desc = "[DAP] open threads" } },
    { dapLeader .. "e", function()
        local sidebar = widgets.sidebar(widgets.expression)
        sidebar.open()
    end, { desc = "[DAP] open expressions" } },
    { dapLeader .. "b", function() require "dap".toggle_breakpoint() end, { desc = "[DAP] toggle breakpoint" } },
    { dapLeader .. "P", function() require "dap".pause() end,             { desc = "[DAP] pause" } },
    { dapLeader .. "c", function() require "dap".continue() end,          { desc = "[DAP] continue" } },
    { dapLeader .. "n", function() require "dap".step_over() end,         { desc = "[DAP] step over" } },
    { dapLeader .. "p", function() require "dap".step_back() end,         { desc = "[DAP] step back" } },
    { dapLeader .. "i", function() require "dap".step_into() end,         { desc = "[DAP] step into" } },
    { dapLeader .. "I", function() require "dap".step_out() end,          { desc = "[DAP] step out" } },
    { dapLeader .. "r", function()
        require "dap".session()
        require "dap".continue()
    end, { desc = "[DAP] start session" } },
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
    { "<leader>e;", "<cmd>Telescope symbols<cr>",         { desc = "[TELESCOPE] emojis" } },
    { "<leader>ej", "<cmd>Telescope jumplist<cr>",        { desc = "[TELESCOPE] jumplist" } },
    { "<leader>ee", "<cmd>Telescope diagnostics<cr>",     { desc = "[TELESCOPE] diagnostics" } },
    { "<leader>eT", "<cmd>Telescope treesitter<cr>",      { desc = "[TELESCOPE] treesitter" } },
    { "<leader>et", "<cmd>Telescope tagstack<cr>",        { desc = "[TELESCOPE] tagstack" } },
    { "<leader>es", "<cmd>Telescope spell_suggest<cr>",   { desc = "[TELESCOPE] spell suggest" } },
    { "<leader>eH", "<cmd>Telescope highlights<cr>",      { desc = "[TELESCOPE] highlights" } },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",       { desc = "[TELESCOPE] help tags" } },
    { "<leader>fb", '<cmd>Telescope buffers<cr>',         { desc = "[TELESCOPE] buffers" } },
    { "<leader>ec", "<cmd>Telescope colorscheme<cr>",     { desc = "[TELESCOPE] colorscheme" } },
    { "<leader>em", "<cmd>Telescope marks<cr>",           { desc = "[TELESCOPE] marks" } },
    { "<leader>fE", ':bdel<cr>:Telescope find_files<cr>', { desc = "[TELESCOPE] find files (delete current buffer)" } },
    { "<leader>fe", ':Telescope find_files<cr>',          { desc = "[TELESCOPE] find files" } },
    { "<leader>ff", ':Telescope find_files<cr>',          { desc = "[TELESCOPE] find files" } },
    -- { "<leader>fe", ':find **/',                          { desc = "Find files" } },
    -- { "<leader>ff", ":find **/",                          { desc = "Find files" } },
    { "<leader>fq", ":Telescope quickfix<cr>",            { desc = "[TELESCOPE] quickfix list" } },
    { "<leader>fF", function()
        local t = require "telescope.builtin"
        t.find_files({ hidden = true, no_ignore = true })
    end, { desc = "[TELESCOPE] open any file, save current buffer in harpoon" } },
    { "<leader>f/", '<cmd>Telescope live_grep<cr>',                              { desc = "[TELESCOPE] grep" } },
    { "<C-S-p>",    "<cmd>Telescope keymaps<cr>",                                { desc = "[TELESCOPE] keymap pallete" } },
    { "<leader>ek", "<cmd>Telescope keymaps<cr>",                                { desc = "[TELESCOPE] keymap pallete" } },
    { "<leader>b/", "<cmd>Telescope current_buffer_fuzzy_find<cr>",              { desc = "[TELESCOPE] buffer fuzzy find" } },
    { "<leader>fH", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon menu" } },
    --}}}
    --Viewers {{{
    { "<leader>eu", "<cmd>lua require('undotree').toggle()<cr>" },
    { "<leader>n",  require 'oil'.toggle_float },
    { "gO", function()
        if vim.g._outline_cmd then
            vim.cmd(vim.g._outline_cmd)
        else
            --fallback
            vim.cmd [[SymbolsOutline]]
        end
    end, { desc = "symbols outline [OR] table of contents" } },
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
    { "<leader>S",        ':split | wincmd j<cr>',                { desc = "[WIN] Top/bottom split" } },
    { "<leader>V",        ':vsplit | wincmd l<cr>',               { desc = "[WIN] Left/right split" } },
    { "<leader>l",        ":tabnext<cr>",                         { desc = "[TAB] Next tab" } },
    { "<leader>h",        ':tabprev<CR>',                         { desc = "[TAB] Previous tab" } },
    { "<leader><c-l>",    ':bn<CR>',                              { desc = "Next buffer" } },
    { "<leader><c-h>",    ':bp<CR>',                              { desc = "Previous buffer" } },
    { "<leader>t",        ':tabnew<CR>',                          { desc = "[TAB] New tab" } },
    { "<leader>q",        ':tabclose<cr>',                        { desc = "[TAB] Tab close" } },
    { "<right>",          "<c-w>>",                               { desc = "[WIN] Grow horizontal" } },
    { "<left>",           "<c-w><",                               { desc = "[WIN] Shrink horizontal" } },
    { "<up>",             "<c-w>+",                               { desc = "[WIN] Grow vertical" } },
    { "<down>",           "<c-w>-",                               { desc = "[WIN] shrink vertical" } },
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
    --lsp {{{
    --}}}
    -- Treesitter {{{
    { "<leader>sr",      function() require "ssr".open() end },
    { "<A-r>",           "<cmd>RegexplainerToggle<cr>" },
    { "<a-t>p",          require("tree-climber").goto_parent },
    { "<a-t>c",          require("tree-climber").goto_child },
    { "<a-t>n",          require "tree-climber".goto_next },
    { "<a-t>p",          require "tree-climber".goto_prev },
    { "<leader>vn",      require("tree-climber").select_node },
    -- { "<a-j>",           require("tree-climber").swap_next },
    -- { "<a-k>",           require("tree-climber").swap_prev },
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
    { "<C-c><C-c>", "<cmd>CccPick<cr>" },
    { "<C-c><C-x>", "<cmd>CccConvert<cr>" },
    -- }}}
    -- lazy {{{
    { "<leader>Lu", "<cmd>Lazy update<cr>" },
    { "<leader>Lx", "<cmd>Lazy clean<cr>" },
    -- }}}
    { "ZF",         require "mini.misc".zoom },
    { "<c-q>",      vim.cmd.cwindow,                           { desc = "[QF] Open quickfix window" } },
    { "<leader>/",  ":silent lgrep! | lwindow<S-Left><S-Left>", { desc = "[QF] :lgrep, then open :lwin" } },
    { "<c-c><c-n>", ":cnext<CR>",                              { desc = "[QF] Next quickfix item" } },
    { "<c-c><c-p>", ":cprev<CR>",                              { desc = "[QF] Previous quickfix item" } },
    { "<leader>O",  "<cmd>Oil<CR>",                            { desc = "Open oil" } },
    { "<c-s-t>", function()
        vim.api.nvim_cmd({
            cmd = "tag",
            range = { vim.v.count1 }
        }, {})
    end, { desc = "[TAG] go to [count] previous tag in the tag stack" } }
}
for _, map in ipairs(nShortcuts) do
    vim.keymap.set("n", map[1], map[2], map[3] or {})
end
--}}}

-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>",     "<C-w>" },
    { "<C-g>$",     "<Esc>$a" },
    { "<C-g>l",     "<Esc>la" },
    { "<C-g>h",     "<Esc>ha" },
    { "<C-g>0",     "<Esc>0i" },
    { "<C-g>^",     "<Esc>^i" },
    { "<C-g>b",     "<Esc>bi" },
    { "<C-g>w",     "<Esc>wi" },
    { "<C-g>B",     "<Esc>Bi" },
    { "<C-g>W",     "<Esc>Wi" },
    { "<c-space>l", "<Esc>:tabnext<CR>" },
    { "<c-space>h", "<Esc>:tabprev<CR>" },
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
    { "DD",              ":ODocument<cr>" },
    { "DC",              ":ChatBotComment<cr>" },
    { "DG",              ":OGen<CR>" },
    { "C",               ":M complete<CR>" },
    -- }}}
    -- move code {{{
    { "mj",              ":m '>+1<CR>gv=gv",                 { desc = "Move up" } },
    { "mk",              ":m '<-2<CR>gv=gv",                 { desc = "Move down" } },
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
