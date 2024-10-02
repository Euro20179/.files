vim.opt.scbk = 100

--New [default](https://github.com/neovim/neovim/commit/20b38677c22b0ff19ea54396c7718b5a8f410ed4)
--if rg is available!!
--`rg --vimgrep -uuu $*` /dev/null 2>&1
--the problem with this is that rg doesn't accept /dev/null v well
vim.opt.grepprg = "rg --vimgrep $*"

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- vim.o.winbar = "%{%v:lua.Winbar()%}"


function GetDiagnostic(severity)
    return vim.diagnostic.get(0, { severity = severity })
end

function FormatstatuslineDiag()
    local text = ""
    local errors = #GetDiagnostic(vim.diagnostic.severity.E)
    local warnings = #GetDiagnostic(vim.diagnostic.severity.W)
    if errors ~= 0 then
        text = text .. "%5*" .. tostring(errors) .. "%*"
    end
    if warnings ~= 0 then
        text = text .. ' %6*⚠' .. tostring(warnings) .. "%*"
    end
    return text
end

local left = '%1*%f%2*%{&modified == v:true ? "*" : ""} %4*%p%%%* %{%v:lua.FormatstatuslineDiag()%}'
local right = '%2*%{&filetype} '
local center = '%3*%{v:lua.GetLspNames()}%*'

vim.opt.statusline = left .. '%=' .. center .. '%=' .. right

vim.diagnostic.config({
    float = {
        border = "single"
    }
})

vim.lsp.buf.hover = function()
    local hc = require"hovercraft"
    if hc.is_visible() then
        hc.enter_popup()
    else
        hc.hover()
    end
end
