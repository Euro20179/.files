function WrapTryGeneric(cmdData)
    if cmdData.range == 0 then
        vim.notify("No range given", vim.log.levels.ERROR)
        return
    end

    local tryWordDefault = "try{"
    local catchWordDefault = "}\rcatch(err){\r}"

    local tryWord = vim.b.wraptry_tryword or tryWordDefault
    if tryWord == "" then
         tryWord = tryWordDefault
    end

    local catchWord = vim.b.wraptry_catchWord or catchWordDefault
    if catchWord == "" then
        catchWord = catchWordDefault
    end

    vim.cmd.norm(tostring(cmdData.line1) .. "GO" .. tryWord)
    vim.api.nvim_cmd({
        cmd = "norm",
        range = { cmdData.line1 + 1 },
        args = { ">" .. tostring(cmdData.line2 - cmdData.line1) .. "j" }
    }, {})
    vim.cmd.norm(tostring(cmdData.line2 + 1) .. "Go" .. catchWord)
    vim.cmd.norm("O")
end

vim.api.nvim_create_user_command("WrapTry", function(cmdData)
    if WrapTry ~= nil then
        WrapTry(cmdData)
    else
        vim.notify("WrapTry does not exist for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
        WrapTryGeneric(cmdData)
    end
end, {
    range = true,
})

