function WrapTry(cmdData)
    if cmdData.range == 0 then
        vim.notify("No range given", vim.log.levels.ERROR)
        return
    end

    vim.cmd.norm(tostring(cmdData.line1) .. "GOtry:")
    vim.api.nvim_cmd({
        cmd = "norm",
        range = {cmdData.line1 + 1},
        args = {">" .. tostring(cmdData.line2 - cmdData.line1) .. "j"}
    }, {})
    vim.cmd.norm(tostring(cmdData.line2 + 1) .. "Go\bexcept Exception as e:\rpass")
end
