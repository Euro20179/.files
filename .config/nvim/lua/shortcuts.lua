local harpoon = require "harpoon"
harpoon:setup()

local widgets = require "dap.ui.widgets"

-- local moveline = require("moveline")
local utilLeader = "<M-u>"

local gitLeader = "<M-g>"

local dapLeader = "<M-d>"

-- local discord = require'discord'
--
-- vim.keymap.set("i", "<c-s>", discord.send_message_bind, { desc = '[DISCORD] send mesasge' })

--Normal Mode{{{
local nShortcuts = {
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
    { dapLeader .. "g", function()
        require "dap".session({ request = "attach", port = 5000 })
        require "dap".continue()
    end, { desc = "[DAP] start attach session" } },
    { dapLeader .. "r", function()
        require "dap".session()
        require "dap".continue()
    end, { desc = "[DAP] start session" } },
    { dapLeader .. "o", require "dapui".toggle,                                              { desc = "[DAP] toggle" } },
    -- }}}
    --telescope {{{
    { "<leader>fj",     function() require "mini.extra".pickers.list { scope = "jump" } end, { desc = "[TELESCOPE] jumplist" } },
    { "<leader>ff",     require "mini.pick".builtin.files,                                   { desc = "[TELESCOPE] find files" } },
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
    { "<leader>fh", require "mini.pick".builtin.help,      { desc = "[TELESCOPE] help tags" } },
    { "<leader>fT", function ()
        local tabs = {}
        for _, tabno in ipairs(vim.api.nvim_list_tabpages()) do
            local tabWin = vim.api.nvim_tabpage_get_win(tabno)
            local tabWinBuf = vim.api.nvim_win_get_buf(tabWin)
            local tabWinBufName = vim.api.nvim_buf_get_name(tabWinBuf)
            tabs[#tabs+1] = tabWinBufName .. ":" .. tabno
        end

        vim.ui.select(tabs, {}, function (item)
            if item == nil then
                return
            end

            local tabInfo = vim.split(item, ":")
            vim.schedule(function()
                vim.api.nvim_set_current_tabpage(tonumber(tabInfo[#tabInfo]))
            end)
        end)
    end, { desc = "[TELESCOPE] tabs" } },
    { "<leader>fb", function()
        local bufs = {}
        for _, bufno in ipairs(vim.api.nvim_list_bufs()) do
            if not vim.api.nvim_buf_is_valid(bufno) then
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
            vim.schedule(function()
                vim.api.nvim_win_set_buf(0, tonumber(sp[#sp]))
            end)
        end)
    end, { desc = "[TELESCOPE] buffers" } },
    { "<leader>f/", require "mini.pick".builtin.grep_live, { desc = "[TELESCOPE] grep" } },
    { "<C-S-p>", function()
        local keys = require "mini.extra".pickers.keymaps()
        if keys == nil then
            return
        end
        vim.api.nvim_feedkeys(keys.lhs, "n", true)
    end, { desc = "[TELESCOPE] keymap pallete" } },
    { "<leader>fH",       function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "harpoon menu" } },
    --}}}
    --Viewers {{{
    { "<leader>eu",       "<cmd>lua require('undotree').toggle()<cr>" },
    { "<leader>O",  require 'oil'.open },
    --}}}
    --buffer/window shortcuts{{{
    { "<leader><leader>", function() harpoon:list():add() end },
    { "<A-j>",            function() harpoon:list():select(1) end },
    { "<A-k>",            function() harpoon:list():select(2) end },
    { "<A-l>",            function() harpoon:list():select(3) end },
    { "<A-;>",            function() harpoon:list():select(4) end },
    { "<A-'>",            function() harpoon:list():select(5) end },
    { "<leader>1",        function() harpoon:list():select(6) end },
    { "<leader>2",        function() harpoon:list():select(7) end },
    { "<leader>3",        function() harpoon:list():select(8) end },
    { "<leader>4",        function() harpoon:list():select(9) end },
    { "<leader>T",        function() GotoTerminalBuf() end },
    --}}}
    -- Git {{{
    { gitLeader .. "l", ":G log<CR>", { desc = "[GIT]: log" } },
    { gitLeader .. "c", "<cmd>G commit<CR>", { desc = "[GIT]: commit" } },
    { gitLeader .. "d",       "<cmd>G diff<cr>", { desc = "[GIT]: diff" } },
    { gitLeader .. "p", "<cmd>G push<CR>", { desc = "[GIT]: push" } },
    -- }}}
    -- Treesitter {{{
    { "glt",             "<cmd>Inspect<cr>" },
    -- }}}
    --syntax highlighting{{{
    { "<A-f>s",          ":set foldmethod=syntax<cr>" },
    { "<A-f>m",          ':set foldmethod=marker<cr>' },
    { "<A-f>e",          ':set foldmethod=expr<cr>' },
    --}}}
    -- Util Functions {{{
    { utilLeader .. "x", ":!chmod +x \"%\"",                 { desc = "[UTIL] chmod +x the current file" } },
    { utilLeader .. "e", ":Neorg exec cursor<CR>" },
    { utilLeader .. "W", "\"=v:lua.Rword()<cr>p",            { desc = "[UTIL] random word" } },
    { utilLeader .. "d", "<cmd>lua Fmt_date()<cr>",          { desc = "[UTIL] Put the date with a format" } },
    { "<C-c><C-c>", function()
        vim.system({ "foot", "goker", vim.fn.expand("<cWORD>") })
    end, { desc = "[UTIL] Open color picker" } },
    -- }}}
    -- lazy {{{
    { "<leader>Lu", "<cmd>DepsUpdate<cr>" },
    { "<leader>Lx", "<cmd>DepsClean<cr>" },
    -- }}}
    { "ZF",         require "mini.misc".zoom },
    { "<leader>fo", "<cmd>Oil<CR>",          { desc = "[FILE] Open oil" } },
    { "<c-s-t>", function()
        vim.api.nvim_cmd({
            cmd = "tag",
            range = { vim.v.count1 }
        }, {})
    end, { desc = "[TAG] go to [count] previous tag in the tag stack" } },
    { "<leader>R", ":Regedit ", { desc = "[REGEDIT] edit a register" } },
    { "<a-m>",     ":make<CR>", { desc = "copmile" } },
}
for _, map in ipairs(nShortcuts) do
    vim.keymap.set("n", map[1], map[2], map[3] or {})
end

if vim.fn.exists("&findexpr") == 0 or vim.opt.findexpr == "" then
    vim.keymap.set("n", "<leader>ff", require "mini.pick".builtin.files, { desc = "[TELESCOPE] find files" })
end

--}}}

-- Insert Mode{{{
local iShortcuts = {
    -- Movement {{{
    { "<C-bs>",     "<C-w>" },
    { "<c-space>l", "<Esc>:tabnext<CR>" },
    { "<c-space>h", "<Esc>:tabprev<CR>" },
    { "<c-w>",      vim.snippet.stop,   { desc = "[SNIPPET] exit" } },
    -- }}}
    -- { "<Right>", require"bropilot".accept_block, { desc = "[COPILOT] accept" } }
}
for _, map in ipairs(iShortcuts) do
    vim.keymap.set("i", map[1], map[2], map[3])
end
--}}}

--Visual Mode{{{
local vShortcuts = {
    { utilLeader .. "e", ":Exec<CR>" },
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
    { "<c-h>",        "<cmd>wincmd h<CR>" },
    { "<c-l>",        "<cmd>wincmd l<CR>" },
    { "<c-k>",        "<cmd>wincmd k<CR>" },
    { "<c-j>",        "<cmd>wincmd j<CR>" },
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

-- vim.keymap.set({ "o", "x" }, "?", function()
--     require "various-textobjs".diagnostic()
-- end)

-- local surround_prefix = "s"
-- local surround_chars = { "{", "[", "(", "'", '"', "<", "}", "]", ")" }
-- local surround = require "visual-surround".surround
-- for _, key in pairs(surround_chars) do
--     vim.keymap.set("v", surround_prefix .. key, function()
--         surround(key)
--     end, { desc = "[visual-surround] " .. key })
-- end
