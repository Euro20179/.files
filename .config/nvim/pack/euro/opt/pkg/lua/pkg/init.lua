---@alias pkg.Spec vim.pack.Spec

---@class pkg.Opts
---@field on_add fun(pkg.Spec): any

local M = {}

local aug = vim.api.nvim_create_augroup("pkg", { clear = true })

---@param spec pkg.Spec[]
---@param opts? pkg.Opts
---calls vim.pack.add with spec, with options
function M.add_raw(spec, opts)
    vim.pack.add(spec)

    if opts == nil then return end

    if opts.on_add then
        opts.on_add(spec)
    end
end

---@param spec pkg.Spec[]
---@param on? "now" | string | {event: vim.api.keyset.events | vim.api.keyset.events[], opts: vim.api.keyset.create_autocmd }
---@param opts? pkg.Opts
---Adds a package on an event [on], with options
function M.add(spec, on, opts)

    if on == nil or on == "now" then
        M.add_raw(spec, opts)
    elseif type(on) == 'string' then
        vim.api.nvim_create_autocmd(on, {
            group = aug,
            once = true,
            callback = function ()
                M.add_raw(spec, opts)
            end
        })
    else
        on.opts.group = aug
        on.opts.once = true
        vim.api.nvim_create_autocmd(on.event, on.opts)
    end
end

local function listPluginNames()
    local plugins = vim.iter(vim.pack.get())
    return plugins:map(function (v)
        return v.spec.name
    end):totable()
end

function PkgUpdateCompl(...)
    return listPluginNames()
end

vim.api.nvim_create_user_command("PkgUpdate", function (data)
    local args = data.fargs
    if #args == 0 then
        args = listPluginNames()
    end
    vim.pack.update(args)
end, { nargs = "*", complete = "customlist,v:lua.PkgUpdateCompl" })

return M
