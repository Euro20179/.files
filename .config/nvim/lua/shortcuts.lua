local harpoon = require "harpoon"
harpoon:setup()

local widgets = require "dap.ui.widgets"

-- local moveline = require("moveline")
local utilLeader = "<M-u>"

local gitLeader = "<M-g>"

local dapLeader = "<M-d>"

local macros = {}

--Normal Mode{{{
local nShortcuts = {
    --Macros {{{
    { "<leader>ms", function()
        local inp = vim.fn.input({ prompt = "register@name: " })
        if inp == "" then
            return
        end
        local dat = vim.split(inp, "@")
        local name = dat[1]
        local reg = dat[2]
        macros[name] = reg
    end, { desc = "[MACRO] Save macro" } },
    { "<leader>mp", function()
        local items = {}
        for k, v in pairs(macros) do
            items[#items + 1] = k .. "@" .. v .. " = " .. vim.fn.getreg(k)
        end
        vim.ui.select(items, { prompt = "Macro to play" }, function(macro)
            if macro == nil then
                return
            end
            local reg = vim.split(macro, "@")[1]
            vim.cmd.norm("@" .. reg)
        end)
    end, { desc = "[MACRO] play macro" } },
    --}}}
    -- dap {{{
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
    --telescope {{{
    { "<leader>ej", function() require "mini.extra".pickers.list { scope = "jump" } end,       { desc = "[TELESCOPE] jumplist" } },
    { "<leader>ee", function() require "mini.extra".pickers.diagnostic({ scope = "all" }) end, { desc = "[TELESCOPE] diagnostics" } },
    { "<leader>ft", function()
        local tagStack = vim.fn.gettagstack(0)
        local items = {}
        for _, value in ipairs(tagStack.items) do
            local filename = vim.api.nvim_buf_get_name(value.bufnr)
            items[#items + 1] = { bufnr = value.bufnr, lnum = value.from[2], col = value.from[3], filename = filename }
        end
        vim.fn.setloclist(0, items)
        vim.cmd.lwin()
    end, { desc = "[LL] tagstack" } },
    { "<leader>fg;", function()
        local chgLst = vim.fn.getchangelist()[1]
        local bufNr = vim.fn.bufnr()
        local bufText = vim.api.nvim_buf_get_lines(bufNr, 0, vim.api.nvim_buf_line_count(bufNr), false)
        for i, _ in pairs(chgLst) do
            chgLst[i].bufnr = bufNr
            chgLst[i].text = bufText[i]
        end
        vim.fn.setloclist(0, vim.fn.reverse(chgLst))
        vim.cmd.lwin()
    end },
    { "<leader>fh", require "mini.pick".builtin.help,                       { desc = "[TELESCOPE] help tags" } },
    { "<leader>fb", function()
        local bufs = {}
        for _, bufno in ipairs(vim.api.nvim_list_bufs()) do
            if not vim.api.nvim_buf_is_loaded(bufno) then
                goto continue
            end
            bufs[#bufs + 1] = vim.api.nvim_buf_get_name(bufno) .. ":" .. bufno
            ::continue::
        end
        vim.ui.select(bufs, {}, function(item)
            if item == nil then
                return
            end
            local sp = vim.split(item, ":")
            vim.api.nvim_win_set_buf(0, tonumber(sp[1]) or 0)
        end)
    end, { desc = "[TELESCOPE] buffers" } },
    { "<leader>fe", ':bdel<cr>:lua require"mini.pick".builtin.files()<cr>', { desc = "[TELESCOPE] find files (delete current buffer)" } },
    { "<leader>ff", require "mini.pick".builtin.files,                      { desc = "[TELESCOPE] find files" } },
    { "<leader>fF", function()
        require "mini.pick".builtin.cli({
            command = { "fd", "-I" },
        })
        -- require "mini.pick".builtin.files({ tool = "fd" }, {spawn_opts = "-I"})
    end, { desc = "[TELESCOPE] open any file, save current buffer in harpoon" } },
    { "<leader>f/", require "mini.pick".builtin.grep_live,                       { desc = "[TELESCOPE] grep" } },
    { "<C-S-p>",    function ()
        local keys = require "mini.extra".pickers.keymaps()
        if keys == nil then
            return
        end
        vim.api.nvim_feedkeys(keys.lhs, "n", true)
    end,                        { desc = "[TELESCOPE] keymap pallete" } },
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
    { "<leader><leader>", function() harpoon:list():add() end },
    { "<A-j>",            function() harpoon:list():select(1) end },
    { "<A-k>",            function() harpoon:list():select(2) end },
    { "<A-l>",            function() harpoon:list():select(3) end },
    { "<A-;>",            function() harpoon:list():select(4) end },
    { "<A-'>",            function() harpoon:list():select(5) end },
    { "<leader>6",        function() harpoon:list():select(6) end },
    { "<leader>7",        function() harpoon:list():select(7) end },
    { "<leader>8",        function() harpoon:list():select(8) end },
    { "<leader>9",        function() harpoon:list():select(9) end },
    { "<leader>T",        function() GotoTerminalBuf() end },
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
    { gitLeader .. "d",       "<cmd>DiffviewOpen<cr>" },
    { gitLeader .. gitLeader, "<cmd>Neogit<cr>" },
    { gitLeader .. "p", function()
        require "neogit".open({ "push" })
    end },
    -- }}}
    --lsp {{{
    --}}}
    -- Treesitter {{{
    { "<leader>sr",      function() require "ssr".open() end },
    { "<A-r>",           "<cmd>RegexplainerToggle<cr>" },
    { "glt",             "<cmd>Inspect<cr>" },
    -- }}}
    --syntax highlighting{{{
    { "<A-f>s",          ":set foldmethod=syntax<cr>" },
    { "<A-f>m",          ':set foldmethod=marker<cr>' },
    { "<A-f>e",          ':set foldmethod=expr<cr>' },
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
    { "<leader>Lu", "<cmd>DepsUpdate<cr>" },
    { "<leader>Lx", "<cmd>DepsClean<cr>" },
    -- }}}
    { "ZF",         require "mini.misc".zoom },
    { "<leader>O",  "<cmd>Oil<CR>",                             { desc = "[FILE] Open oil" } },
    { "<c-s-t>", function()
        vim.api.nvim_cmd({
            cmd = "tag",
            range = { vim.v.count1 }
        }, {})
    end, { desc = "[TAG] go to [count] previous tag in the tag stack" } },
    { "<leader>R", ":Regedit ", { desc = "[REGEDIT] edit a register" }},
}
for _, map in ipairs(nShortcuts) do
    vim.keymap.set("n", map[1], map[2], map[3] or {})
end
--}}}
--}}}

-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>",     "<C-w>" },
    { "<c-space>l", "<Esc>:tabnext<CR>" },
    { "<c-space>h", "<Esc>:tabprev<CR>" },
    { "<c-w>", vim.snippet.exit, {desc = "[SNIPPET] exit"}}
    -- }}}
}
for _, map in ipairs(iShortcuts) do
    vim.keymap.set("i", map[1], map[2], map[3])
end
--}}}

--Visual Mode{{{
local vShortcuts = {
    { utilLeader .. "e", ":Exec<CR>" },
    --treesitter{{{
    { "<leader>sr",      function() require "ssr".open() end },
    --}}}
    -- move code {{{
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
    { "<c-\\><c-\\>", "<c-\\><c-n>" },
    { "<c-h>", "<cmd>wincmd h<CR>" },
    { "<c-l>", "<cmd>wincmd l<CR>" },
    { "<c-k>", "<cmd>wincmd k<CR>" },
    { "<c-j>", "<cmd>wincmd j<CR>" },
}
for _, map in ipairs(tShortcuts) do
    vim.keymap.set("t", map[1], map[2])
end
-- }}}

-- popup menu{{{
--here as example
-- vim.cmd [[
--     aunmenu PopUp
--     nnoremenu PopUp.hi :lua print("hi")<cr>
-- ]]
--}}}

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
