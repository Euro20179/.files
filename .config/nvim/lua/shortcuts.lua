vim.g.mapleader = " "

local utilLeader = "<A-u>"

--Normal Mode{{{
local nShortcuts = {
    --copy shortcuts {{{
    { "<leader>p", '"+p' },
    { "<leader>P", '"+P' },
    { "<leader>y", '"+y' },
    { "<leader>Y", '"+Y' },
    { "<leader>d", '"+d' },
    { "<leader>d", '"+d' },
    { "<leader>c", '"+c' },
    { "<leader>C", '"+C' },
    { "<leader>x", '"+x' },
    { "<leader>X", '"+X' },
    { "Sb", "\"_" },
    { "SS", "\"+" },
    { "Sy", "\"+yy" },
    { "Sd", "\"+dd" },
    { "Sc", "\"+cc" },
    --}}}
    --telescope {{{
    { "<leader>e;", ":Telescope symbols<cr>"},
    { "<leader>ej", ":Telescope jumplist<cr>" },
    { "<leader>ee", ":Telescope diagnostics<cr>" },
    { "<leader>eT", ":Telescope treesitter<cr>" },
    { "<leader>et", "<cmd>Telescope tagstack<cr>" },
    { "<leader>es", "<cmd>Telescope spell_suggest<cr>" },
    { "<leader>eH", "<cmd>Telescope highlights<cr>"},
    --}}}
    --buffer/window shortcuts{{{
    { "<leader>S", ':split \\| wincmd j<cr>' },
    { "<leader>V", ':vsplit \\| wincmd l<cr>' },
    { "<leader>l", ":tabnext<cr>" },
    { "<S-Tab>", ':tabprev<CR>' },
    { "<leader>h", ':tabprev<CR>' },
    { "<leader><c-l>", ':bn<CR>' },
    { "<leader><c-h>", ':bp<CR>' },
    { "<leader>t", ':tabnew<CR>' },
    { "<leader>q", ':tabclose<cr>' },
    { "ZA", ":qa<CR>" },
    { "ZW", ":wqa<CR>" },
    { "<leader>T", ":ToggleTerm<cr>" },
    { "<leader>n", ":CHADopen<cr>" },
    { "<leader>N", function()
        require("ranger-nvim").open(true)
    end},
    { "<leader>fh", ":Telescope help_tags<cr>" },
    { "<right>", "<c-w>>" },
    { "<left>", "<c-w><" },
    { "<up>", "<c-w>+" },
    { "<down>", "<c-w>-" },
    { "<leader>F", "<cmd>Ex<cr>" },
    { "<leader>vw", function()
        vim.cmd [[:cd ~/Documents/vimwiki]]
        vim.cmd [[:e index.norg]]
    end
    },
    --}}}
    -- Git {{{
    { "<leader>gl",
        function()
            vim.cmd [[new | wincmd j | read !git log]]
            vim.o.filetype = "gitlog"
            vim.cmd [[norm gg]]
            vim.keymap.set("n", "q", ":q<cr>", { buffer = vim.api.nvim_get_current_buf() })
        end
    },
    { "<leader>gD", function()
        require("user.telescope").telescope_diff()
    end },
    { "<leader>gd",
        function()
            vim.cmd [[!git diff]]
        end
    },
    -- }}}
    --emmet{{{
    { "<leader>,", "<c-y>," },
    --}}}
    --FIND{{{
    { "<leader>fb", ':Telescope buffers<cr>' },
    { "<leader>fe", ':Telescope find_files<cr>' },
    { "<leader>ff", ':tabnew<cr>:Telescope find_files<cr>' },
    { "<leader>fj", ':Telescope jumplist<cr>' },
    { "<leader>f/", ':Telescope live_grep<cr>' },
    { "<leader>b/", ":Telescope current_buffer_fuzzy_find<cr>"},
    { "<leader>ft", ':lua require("telescope-tabs").list_tabs()<cr>' },
    --}}}
    --lsp {{{
    { "<leader>#", ":!ctags -R .<cr>" },
    { "<leader>fF", ":Telescope tags<cr>" },
    { "<leader>f#", ":Telescope tags<cr>" },
    { "<leader>fs", ':Telescope lsp_document_symbols<cr>' },
    { "<leader>fS", ':Telescope lsp_workspace_symbols<cr>' },
    { "<leader>fr", ':Telescope lsp_references<cr>' },
    { "<leader>E", ":TroubleToggle<cr>" },
    { "<leader>r", ":IncRename " },
    { "<leader>e", require("lsp_lines").toggle },
    { "<a-e>", function()
        vim.diagnostic.open_float()
    end
    },
    { "glh", vim.lsp.buf.hover },
    { "<leader>a", "<cmd>CodeActionMenu<cr>"    },
    { "<leader>A", function()
        local n = 0
        vim.lsp.buf.code_action({ filter = function(a)
            n = n + 1
            return n == 1
        end, apply = true })
    end
    },
    { "]d", function()
        vim.diagnostic.goto_next()
    end
    },
    { "]D", function()
        vim.diagnostic.goto_next()
        local n = 0
        vim.lsp.buf.code_action({ filter = function(a)
            n = n + 1
            return n == 1
        end, apply = true })
    end
    },
    { "[d", function()
        vim.diagnostic.goto_prev({})
    end
    },

    { "[D", function()
        vim.diagnostic.goto_prev({})
        local n = 0
        vim.lsp.buf.code_action({ filter = function(a)
            n = n + 1
            return n == 1
        end, apply = true })
    end
    },
    {
        "<leader>=",
        function()
            vim.lsp.buf.format { async = true }
        end
    },
    --}}}
    --DAP{{{
    { "<a-d>", function()
        vim.g.euro_debug_mode = not vim.g.euro_debug_mode
        local filetype = vim.filetype.match({ buf = 0 })
        local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
        if vim.g.euro_debug_mode == true then
            -- local js_name = vim.split(filename, ".", {plain = true})[1] .. ".js"
            -- if filetype == "typescript" then
            --     if vim.fs.find(js_name, {}) then
            --         vim.api.nvim_cmd({
            --             args = {js_name},
            --             cmd = "e",
            --         }, {})
            --     end
            -- end

            vim.keymap.set("n", "b", function()
                require "dap".toggle_breakpoint()
            end)
            require("dapui").open()
        else
            -- local ts_name = vim.split(filename, ".", {plain = true})[1] .. ".ts"
            -- if filetype == "javascript" then
            --     if vim.fs.find(ts_name, {}) then
            --         vim.api.nvim_cmd({
            --             args = {ts_name},
            --             cmd = "e",
            --         }, {})
            --     end
            -- end
            vim.keymap.del("n", "b")
            require "dapui".close()
        end
    end },
    --}}}
    -- Treesitter {{{
    { "<leader>R", "<cmd>AerialToggle<cr>" },
    { "<A-r>", "<cmd>RegexplainerToggle<cr>" },
    { "<a-h>", require("tree-climber").goto_parent },
    { "<a-l>", require("tree-climber").goto_child },
    { "<a-j>", require("tree-climber").goto_next },
    { "<a-k>", require("tree-climber").goto_prev },
    { "<leader>v", require("tree-climber").select_node },
    { "<leader><a-j>", require("tree-climber").swap_next },
    { "<leader><a-k>", require("tree-climber").swap_prev },
    { "glt", ":TSHighlightCapturesUnderCursor<cr>" },
    { "<leader>o", "<cmd>SymbolsOutlineOpen<cr>"},
    -- }}}
    --syntax highlighting{{{
    { "<A-f>s", ":set foldmethod=syntax<cr>" },
    { "<A-f>m", ':set foldmethod=marker<cr>' },
    { "<C-n>", ':noh<CR>' },
    { "<C-s>", ':setlocal spell! spelllang=en_us<CR>' },
    { "<A-s>", ':syntax sync fromstart<CR>' },
    { "<A-c>", function()
        local c = require("colorizer")
        if c.is_buffer_attached() then
            c.detach_from_buffer()
        else
            c.attach_to_buffer(0, { mode = "foreground", css = true })
        end
    end },
    --}}}
    --normal movement {{{
    { "<c-l>", "<C-w>l" },
    { "<c-j>", "<C-w>j" },
    { "<c-h>", "<C-w>h" },
    { "<c-k>", "<C-w>k" },
    --}}}
    -- Util Functions {{{
    { utilLeader .. "W", "\"=v:lua.Rword()<cr>p" },
    { utilLeader .. "y", function()
        Ytfzf({ _on_done = function(selection)
            local data = vim.split(selection[1], "|")
            local url = data[#data]
            vim.cmd([[!mpv ]] .. "\"" .. url .. "\"")

        end })
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
    { "<leader>m", function()
        vim.ui.input({ prompt = "Manual: " }, function(data)
            vim.cmd("e man://" .. data)
        end)
    end },
    { "<C-c>", "<cmd>CccPick<cr>" },
    { "<a-x>", "<cmd>CccConvert<cr>" },
    -- }}}
    -- Wiki {{{
    { "<leader>W", "<cmd>cd ~/Documents/vimwiki/norg-home | e index.norg<cr>" },
    -- }}}
}
for _, map in ipairs(nShortcuts) do
    vim.keymap.set("n", map[1], map[2], map[3] or {})
end
--}}}

-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>", "<C-w>" },
    { "<C-g>$", "<Esc>$a" },
    { "<C-g>l", "<Esc>la" },
    { "<C-g>h", "<Esc>ha" },
    { "<C-g>0", "<Esc>0i" },
    { "<C-g>^", "<Esc>^i" },
    { "<C-g>b", "<Esc>bi" },
    { "<C-g>w", "<Esc>wi" },
    { "<C-g>B", "<Esc>Bi" },
    { "<C-g>W", "<Esc>Wi" },
    { "<c-space>l", "<Esc>:tabnext<CR>" },
    { "<c-space>h", "<Esc>:tabprev<CR>" },
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
    { "<leader>d", "\"+d" },
    { "<leader>c", "\"+c" },
    { "<leader>p", "\"+p" },
    -- }}}
    -- indentation {{{
    { "<", "<gv" },
    { ">", ">gv" },
    --}}}
    --treesitter{{{
    { "<a-h>", require("tree-climber").goto_parent },
    { "<a-l>", require("tree-climber").goto_child },
    { "<a-j>", require("tree-climber").goto_next },
    { "<a-k>", require("tree-climber").goto_prev },
    --}}}
    -- chatbot{{{
    { "D", ":ChatBotDocument<cr>" },
    { "C", ":ChatBotComment<cr>" },
    -- }}}
}
for _, map in ipairs(vShortcuts) do
    vim.keymap.set("v", map[1], map[2])
end --}}}

-- Select Mode {{{
local sShortcuts = {
    --luasnip {{{
    { "<Tab>", "<cmd>lua require('luasnip').jump(1)<Cr>" },
    { "<S-Tab>", "<cmd>lua require('luasnip').jump(-1)<Cr>" },
    --visual also binds this for some reason?
    { "C", "C", expr = true },
    { "D", "D", expr = true },
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
--mostly here as example
vim.cmd [[
aunmenu PopUp
nnoremenu PopUp.Terminal :ToggleTerm<cr>
]]
--}}}
