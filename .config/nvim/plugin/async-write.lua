--[==[
This plugin is simply meant to make :w asyncronous when writing to my sshfs mounts
]==]

vim.api.nvim_create_autocmd({"BufNew","VimEnter"}, {
    pattern = vim.fn.expand("$CLOUD") .. "/*",
    callback = function ()
        vim.api.nvim_create_autocmd("BufWriteCmd", {
            callback = function()
                local file = vim.fn.expand("%:p")

                local curBuf = vim.api.nvim_win_get_buf(0)

                vim.notify("Asyncronously writing...")

                vim.uv.fs_stat(file, function(err, file_data)
                    if err ~= nil then
                        if not vim.startswith(err, "ENOENT") then
                            vim.schedule(function()
                                vim.notify("Failed to stat file " .. err, vim.log.levels.ERROR)
                            end)
                            return
                        end

                        -- if the file doesn't exist, set file_data
                        -- this is mode: 0o655
                        file_data = { mode = 0b110110110, size = 0 }
                    end

                    local mode = file_data.mode
                    local size = file_data.size

                    vim.uv.fs_open(file, "w", mode, function(err, fd)
                        if err ~= nil then
                            vim.schedule(function ()
                                vim.notify("Failed to open file " .. err, vim.log.levels.ERROR)
                            end)
                            return
                        end

                        vim.schedule(function()
                            local lines = table.concat(
                                vim.api.nvim_buf_get_lines(curBuf, 0, vim.api.nvim_buf_line_count(curBuf), false),
                                "\n"
                            )
                            vim.uv.fs_write(fd, lines, nil, function(err, bytes)
                                if err ~= nil then
                                    vim.notify("Failed to write file " .. err, vim.log.levels.ERROR)
                                    return
                                end

                                vim.uv.fs_close(fd, function(err, success)
                                    if not success or err ~= nil then
                                        vim.notify("Failed to close file... however the data was already written\n" .. err, vim.log.levels.WARN)
                                    end
                                end)

                                vim.schedule(function()
                                    local lineCount = vim.api.nvim_buf_line_count(curBuf)
                                    vim.notify(string.format([["%s" %dL, %dB written]], file, lineCount, size))
                                    vim.bo.modified = false
                                end)
                            end)
                        end)
                    end)
                end)
            end,
            buffer = tonumber(vim.fn.expand("<abuf>"))
        })
    end
})
