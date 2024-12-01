vim.filetype.add({
    extension = {
        mmfml = "mmfml",
        nu = "nu",
        txt = function(path)
            if path:match("nvim/doc/.*%.txt$") then
                return "help"
            end
            return "text"
        end
    },
    pattern = {
        [".*%.config/hypr/.*%.conf"] = "hyprlang",
        [".*Documents/TODO"] = "markdown",
        [".*"] = {
            ---@diagnostic disable-next-line: unused-vararg
            function(path, bufnr, ...)
                local line1 = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
                if line1 == nil then
                    return
                end

                --nvim lua {{{
                if vim.endswith(line1, "nvim -l") then
                    return "lua"
                end
                --}}}

                --nvim -S {{{
                if vim.endswith(line1, "nvim -S") then
                    if vim.endswith(path, ".lua") then
                        return "lua"
                    end
                    return "vim"
                end
                --}}}

                --pacman {{{
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
                --}}}
            end
        }
    }
})
