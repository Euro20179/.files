-- local widgets = require "dap.ui.widgets"

-- local moveline = require("moveline")
local utilLeader = "<M-u>"

local gitLeader = "<M-g>"

local dapLeader = "<M-d>"

vim.cmd [[
    function OpenClrPicker(context = {}, type = '') abort
        if a:type == ''
            let &operatorfunc = function('OpenClrPicker', [#{test: 3}])
            return "g@"
        endif
        let start = getpos("'[")
        let end = getpos("']")
        let text = nvim_buf_get_text(0, start[1] - 1, start[2] - 1, end[1] - 1, end[2], [])
        if text[0] != ''
            let temp = tempname()
            let newClr = trim(system('foot -d none sh -c "goker \"' .. text[0] .. '\" > ' .. temp .. '"'))
            let newClr = readfile(temp)
            call delete(temp)
            if newClr[0] != ""
                call nvim_buf_set_text(0, start[1] - 1, start[2] - 1, end[1] - 1, end[2], newClr)
            endif
        endif
    endfun
    nnoremap <expr> <c-c> OpenClrPicker()
]]

vim.keymap.set("n", "<c-c><c-c>", function()
    vim.system({ 'foot', 'goker', vim.fn.expand("<cWORD>") })
end, { desc = "[UTIL]: color picker" })

-- local discord = require'discord'
--
-- vim.keymap.set("i", "<c-s>", discord.send_message_bind, { desc = '[DISCORD] send mesasge' })

-- z= override to use vim.ui.select {{{
vim.keymap.set("n", "z=", function()
    local word = vim.fn.expand("<cword>")
    vim.ui.select(vim.fn.spellsuggest(word), {
        prompt = "fix spell"
    }, function(item)
        if item == nil then
            return
        end

        vim.cmd.norm("ciw" .. item)
    end)
end)
-- }}}

--Normal Mode{{{
local nShortcuts = {
    { dapLeader .. "b", function() require "lua.user.plugin-setup.dap".toggle_breakpoint() end, { desc = "[DAP] toggle breakpoint" } },
    { dapLeader .. "P", function() require "lua.user.plugin-setup.dap".pause() end,             { desc = "[DAP] pause" } },
    { dapLeader .. "c", function() require "lua.user.plugin-setup.dap".continue() end,          { desc = "[DAP] continue" } },
    { dapLeader .. "n", function() require "lua.user.plugin-setup.dap".step_over() end,         { desc = "[DAP] step over" } },
    { dapLeader .. "p", function() require "lua.user.plugin-setup.dap".step_back() end,         { desc = "[DAP] step back" } },
    { dapLeader .. "i", function() require "lua.user.plugin-setup.dap".step_into() end,         { desc = "[DAP] step into" } },
    { dapLeader .. "I", function() require "lua.user.plugin-setup.dap".step_out() end,          { desc = "[DAP] step out" } },
    { dapLeader .. "g", function()
        require "lua.user.plugin-setup.dap".session({ request = "attach", port = 5000 })
        require "lua.user.plugin-setup.dap".continue()
    end, { desc = "[DAP] start attach session" } },
    { dapLeader .. "r", function()
        require "lua.user.plugin-setup.dap".session()
        require "lua.user.plugin-setup.dap".continue()
    end, { desc = "[DAP] start session" } },
    -- { dapLeader .. "o", require "dapui".toggle,                                              { desc = "[DAP] toggle" } },
    -- }}}
    --telescope {{{
    { "<leader>fj", function() require "mini.extra".pickers.list { scope = "jump" } end, { desc = "[TELESCOPE] jumplist" } },
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
    { "<leader>fh", function()
        require "mini.pick".builtin.help()
    end, { desc = "[TELESCOPE] help tags" } },
    { "<leader>fT", function()
        local tabs = {}
        for _, tabno in ipairs(vim.api.nvim_list_tabpages()) do
            local tabWin = vim.api.nvim_tabpage_get_win(tabno)
            local tabWinBuf = vim.api.nvim_win_get_buf(tabWin)
            local tabWinBufName = vim.api.nvim_buf_get_name(tabWinBuf)
            tabs[#tabs + 1] = tabWinBufName .. ":" .. tabno
        end

        vim.ui.select(tabs, {}, function(item)
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
    { "<leader>f/", require "mini.pick".builtin.grep_live,                               { desc = "[TELESCOPE] grep" } },
    { "<C-S-p>", function()
        local keys = require "mini.extra".pickers.keymaps()
        if keys == nil then
            return
        end
        vim.api.nvim_feedkeys(keys.lhs, "n", true)
    end, { desc = "[TELESCOPE] keymap pallete" } },
    --}}}
    --Viewers {{{
    { "<leader>eu", function()
        vim.cmd.Undotree()
        vim.cmd.wincmd("H")
        vim.api.nvim_win_set_width(0, 40)
    end },
    { "<leader>O",        require 'oil'.open },
    --}}}
    -- Git {{{
    { gitLeader .. "l",   ":G log<CR>",                                                { desc = "[GIT]: log" } },
    { gitLeader .. "c",   "<cmd>G commit<CR>",                                         { desc = "[GIT]: commit" } },
    { gitLeader .. "d",   "<cmd>G diff<cr>",                                           { desc = "[GIT]: diff" } },
    { gitLeader .. "p",   "<cmd>G push<CR>",                                           { desc = "[GIT]: push" } },
    -- }}}
    -- Treesitter {{{
    { "glt",              "<cmd>Inspect<cr>" },
    { "[h", function()
        local findHL = require "find-highlight"
        local sr, sc, el, ec = findHL.prevhl("@markup.heading", vim.fn.line(".") - 1)
        if not sr then return end
        vim.fn.setpos(".", { 0, sr + 1, sc + 1 })
    end, { desc = "[JUMP]: jump to previous @markup.heading" } },
    { "]h", function()
        local findHL = require "find-highlight"
        local sr, sc, el, ec = findHL.nexthl("@markup.heading", vim.fn.line(".") + 1)
        if not sr then return end
        vim.fn.setpos(".", { 0, sr + 1, sc + 1 })
    end, { desc = "[JUMP]: jump to next @markup.heading" } },
    -- }}}
    --syntax highlighting{{{
    { "<A-f>s",          ":set foldmethod=syntax<cr>" },
    { "<A-f>m",          ':set foldmethod=marker<cr>' },
    { "<A-f>e",          ':set foldmethod=expr<cr>' },
    --}}}
    -- Util Functions {{{
    { utilLeader .. "x", ":!chmod +x \"%\"<CR>",      { desc = "[UTIL] chmod +x the current file" } },
    { utilLeader .. "e", ":Neorg exec cursor<CR>" },
    { utilLeader .. "W", "\"=v:lua.Rword()<cr>p",     { desc = "[UTIL] random word" } },
    { utilLeader .. "d", ":!rm \"%\"<CR>",            { desc = "[UTIL] Delete the current file" } },
    -- { "<C-c><C-c>", OpenCLRPicker, { desc = "[UTIL] Open color picker", expr = true } },
    -- }}}
    -- lazy {{{
    { "<leader>Lu",      vim.pack.update },
    { "<leader>Lx",      function()
        vim.iter(vim.pack.get())
            :filter(function(v) return not v.active end)
            :map(function(v) return v.spec.name end)
            :map(vim.pack.del)
    end },
    -- { "<leader>Lx", "<cmd>DepsClean<cr>" },
    -- }}}
    { "ZF", function()
        require "mini.misc".zoom(0, {
            width = vim.o.columns - 10,
            height = vim.o.lines - 4,
            col = 5,
            row = 2,
            border = "single",
            title = vim.api.nvim_buf_get_name(0)
        })
    end },
    { "<c-s-i>", "<cmd>InspectTree<CR>", { desc = "[TREESITTER] Open InspectTree" } },
    { "<c-s-t>", function()
        vim.api.nvim_cmd({
            cmd = "tag",
            range = { vim.v.count1 }
        }, {})
    end, { desc = "[TAG] go to [count] previous tag in the tag stack" } },
    { "<a-m>",   ":make<CR>",            { desc = "compile" } },
    { "g:",      ":= ",                  { desc = "[CMD]: lua expression" } },
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
    { "<c-bs>", vim.snippet.stop, { desc = "[SNIPPET] exit" } },
    { "<a-t>", "<c-r>=strftime('%D %H:%M:%S')<CR>", { desc = "[INSERT] date" } },
}
for _, map in ipairs(iShortcuts) do
    vim.keymap.set("i", map[1], map[2], map[3])
end
--}}}

-- --Visual Mode{{{
-- local vShortcuts = {
--     { utilLeader .. "e", ":Exec<CR>" },
-- }
-- for _, map in ipairs(vShortcuts) do
--     vim.keymap.set("x", map[1], map[2])
-- end --}}}

-- Select Mode {{{
local sShortcuts = {
    --luasnip {{{
    { "<Tab>",   "<cmd>lua vim.snippet.jump(1)<Cr>" },
    { "<S-Tab>", "<cmd>lua vim.snippet.jump(-1)<Cr>" },
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

--extra {{{

--only exists in some filetypes
vim.keymap.set("x", "<a-u>w", ":'<,'>WrapTry<CR>", { desc = "[UTIL] Wrap try" })
vim.keymap.set("n", "<a-u>w", ":.WrapTry<CR>", { desc = "[UTIL] Wrap try" })
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
