local function save_session()
    local finds = vim.fs.find(".git", { upward = true })
    local projname = ""
    if #finds == 0 then
        return
    else
        projname = string.gsub(finds[1], ".*/([^/]*)/.git$", "%1")
    end

    if projname == "" or projname == nil then
        return
    end

    vim.cmd.mksession{
        args = {'$VIM_SESSIONS/' .. projname .. '.vim'},
        bang = true
    }
end

local timer = vim.uv.new_timer()
timer:start(10000, 10000, vim.schedule_wrap(save_session))


vim.api.nvim_create_user_command("SS", save_session, {})
