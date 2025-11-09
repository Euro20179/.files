vim.fn.setenv("NVIM", vim.v.servername)

vim.opt.scbk = 100

vim.opt.undofile = true

vim.opt.fillchars = { msgsep = "‾" }

vim.opt.winborder = "single"

-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.g.health = { style = "float" }

vim.diagnostic.config({
    float = {
        border = "single"
    }
})

require "vim._extui".enable {
    enable = true,
}

-- vim.lsp.buf.hover = function()
--     local hc = require"hovercraft"
--     if hc.is_visible() then
--         hc.enter_popup()
--     else
--         hc.hover()
--     end
-- end

vim.o.winbar =
[====[%{luaeval("vim.fn.join(vim.iter(require'harpoon':list().items):enumerate():map(function(i, item) return tostring(i) .. ' ' .. item.value end):filter(function(item) return item ~= '' end):totable(), ' | ')")}]====]

vim.o.conceallevel = 1

-- ui stuff {{{
vim.ui.select = require "mini.pick".ui_select

vim.diagnostic.config({ virtual_text = true, signs = true })

---@diagnostic disable-next-line
vim.ui.open = function(item, opts)
    local expanded = vim.fn.expand(item)
    local fullPath = ""

    --if url
    if item:find("^%w+:") then
        fullPath = item
        --if absolute
    elseif vim.startswith(expanded, "~") or
        vim.startswith(expanded, "/")
    then
        fullPath = expanded
        --otherwise normalize
    else
        -- this should not be the default way to merge paths lmao
        fullPath = vim.fs.normalize(
            vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":p")
            ..
            vim.fn.expand(item)
        )
    end

    local cmd = { "linkhandler" }
    if opts ~= nil and opts.cmd ~= nil then
        ---@type string[]
        cmd = opts.cmd
    end

    cmd[#cmd + 1] = fullPath
    vim.system(cmd)
end

if vim.hl and vim.hl.on_yank ~= nil then
    local conf_group = vim.api.nvim_create_augroup("conf", {
        clear = true
    })

    vim.api.nvim_create_autocmd("TextYankPost", {
        group = conf_group,
        callback = function()
            vim.hl.on_yank({ timeout = 100, higroup = "Visual" })
        end
    })
end


-- }}}

--neovide {{{
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_opacity = 0.7
-- }}}
