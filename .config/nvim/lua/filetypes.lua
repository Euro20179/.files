vim.filetype.add({
    pattern = {
        [".*%.config/hypr/.*%.conf"] = "hyprland",
        [".*"] = {
            function(path, bufnr, ...)
                local line1 = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                if vim.endswith(line1, "nvim -l") then
                    return "lua"
                end
                local pkgData = vim.split(line1, " ", {})
                if #pkgData == 1 then
                    return
                end
                local o = vim.system({"pacman", "-Qi", pkgData[1]}):wait()
                if o.code == 1 then
                    return
                end
                local stdout = o.stdout
                if stdout == nil then
                    return
                end
                local lines = vim.split(stdout, "\n")
                local versionLine = lines[2]
                local version = vim.split(versionLine, " : ")[2]
                if version == pkgData[2] then
                    return 'pacman-package-list'
                else
                    return
                end
            end
        }
    }
})
