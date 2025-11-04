vim.opt.scbk = 100

vim.opt.undofile = true

vim.opt.fillchars = { msgsep = "‾" }

vim.opt.winborder = "single"

vim.g.health = {style = "float"}

vim.diagnostic.config({
    float = {
        border = "single"
    }
})

require"vim._extui".enable {
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

vim.o.winbar = [====[%{luaeval("vim.fn.join(vim.iter(require'harpoon':list().items):enumerate():map(function(i, item) return tostring(i) .. ' ' .. item.value end):filter(function(item) return item ~= '' end):totable(), ' | ')")}]====]

vim.o.conceallevel = 1
