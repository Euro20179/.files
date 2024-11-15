vim.opt.scbk = 100

vim.opt.undofile = true

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

-- vim.o.winbar = "%{%v:lua.Winbar()%}"

function GetDiagnostic(severity)
    return vim.diagnostic.get(0, { severity = severity })
end

---@class GitStatsCache
---@field add? string
---@field sub? string
local gitStatsCache = {}

local function calcGitStats()
    local cmd = vim.system({ "git", "diff", "--numstat", vim.fn.expand("%")}, {}):wait()
    if cmd.stdout == "" or cmd.code ~= 0 then
        gitStatsCache.add = "0"
        gitStatsCache.sub = "0"
        return "", ""
    end
    local data = vim.split(cmd.stdout, "\t")
    local add = data[1]
    local sub = data[2]
    gitStatsCache.add = add or "0"
    gitStatsCache.sub = sub or "0"
    return add, sub
end

vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function ()
        local co = coroutine.create(function()
            local add, sub = calcGitStats()
            gitStatsCache.add = add
            gitStatsCache.sub = sub
        end)
        coroutine.resume(co)
    end
})

function GetGitStats()
    local add = gitStatsCache.add
    local sub = gitStatsCache.sub
    if add == nil then
        add, sub = calcGitStats()
    end
    if (add == "0" and sub == "0") or (add == "" and sub == "") then
        return ""
    end
    return " (%#DiffAdd#+" .. add .. " %#DiffDelete#-" .. sub .. "%*) "
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

local left = '%1*%f%2*%{&modified == v:true ? "*" : ""}%{%v:lua.GetGitStats()%} %4*%p%%%* %{%v:lua.FormatstatuslineDiag()%}'
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
