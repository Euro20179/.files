function Rword()
    local words = {}
    for line in io.lines("/home/euro/Documents/words.txt") do
        words[#words + 1] = line
    end
    return words[math.random(1, #words)]
end

function Ytfzf(data)
    require("user.telescope").telescope_ytfzf(data)
end

function EditSheet()
    local file = vim.api.nvim_buf_get_name(0)
    GotoTerminalBuf()
    vim.api.nvim_feedkeys('i' .. "sheet " .. file .. "\n", "n", false)
end

function PreviewFile()
    local filename = vim.api.nvim_buf_get_name(0)
    local out = vim.fn.tempname()
    local command = ({
        asciidoc = { "asciidoc", "-o", out, filename },
        markdown = { "pandoc", "-fgfm", "-thtml", "-o", out, filename }
    })[vim.bo.filetype]

    if command == nil then
        vim.print(vim.bo.filetype .. " Does not have a preview command")
        return
    end

    vim.system(command):wait()

    local browser = vim.fn.getenv("BROWSER_SCRIPTING") or vim.fn.getenv("BROWSER") or "firefox"
    vim.cmd.echo('"' .. out .. '"')
    vim.system({ browser, out })
end

function Diff_since_tag()
    vim.ui.input({ prompt = "Tag: " }, function(text)
        vim.cmd([[read !git diff ]] .. text)
    end)
end

function Fmt_date()
    vim.ui.input({ prompt = "Date Fmt: " }, function(text)
        local date_line = vim.fn.line(".")
        local date_col = vim.fn.col(".")
        local date = "" .. os.date(text)
        vim.api.nvim_buf_set_text(0, date_line - 1, date_col - 1, date_line - 1, date_col - 1, { date })
    end)
end

function Word_count()
    vim.api.nvim_cmd({
        addr = "line",
        args = { "detex", "%", "|", "wc", "-w" },
        cmd = "!",
        magic = {
            bar = false,
            file = true
        }
    }, {})
end

function Winbar()
    local text = " "
    text = text .. require 'nvim-navic'.get_location()
    return text
end

function P(...)
    vim.print(...)
end

function ChatBotComment(data)
    OllamaDocument(data)
end

-- function ChatBotDocument(data)
--     _chatbotmain(data, "Add documentation")
-- end

function GotoTerminalBuf()
    local harpoon = require "harpoon"
    for _, tid in ipairs(vim.api.nvim_list_tabpages()) do
        for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(tid)) do
            local bid = vim.api.nvim_win_get_buf(wid)
            local name = vim.api.nvim_buf_get_name(bid)
            if vim.startswith(name, "term://") then
                vim.api.nvim_set_current_tabpage(tid)
                vim.api.nvim_tabpage_set_win(tid, wid)
                return
            end
        end
    end
    -- if no term buf found
    harpoon:list():append()
    vim.cmd.terminal()
end

function DisplayImg(file_path)
    local file_name = vim.api.nvim_buf_get_name(0)
    if type(file_path) == "string" then
        file_name = file_path
    elseif type(file_path) == "table" and file_path.args ~= nil and file_path.args ~= "" then
        file_name = file_path.args
    end
    local image_api = require('image')

    local buf = vim.api.nvim_create_buf(true, false)
    local image = image_api.from_file(file_name, {
        buffer = buf,
    })
    vim.api.nvim_open_win(buf, true, { relative = "win", row = 0, col = 0, width = 1, height = 1 })
    vim.keymap.set("n", "q", "<cmd>q<cr>", {
        buffer = buf
    })
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf,
        callback = function()
            image:clear()
        end
    })
    image:render()
end

function ExecSelection(cmdData)
    local lines
    if #cmdData.fargs ~= 0 then
        lines = { table.concat(cmdData.fargs, " ") }
    else
        lines = vim.api.nvim_buf_get_lines(0, cmdData.line1 - 1, cmdData.line2, false)
    end
    if cmdData.bang then
        vim.cmd["!"](table.concat(lines, ";"))
    else
        GotoTerminalBuf()
        vim.api.nvim_feedkeys('i' .. table.concat(lines, "\n") .. "\n", "n", false)
    end
end

function OllamaGen(cmdData)
    local model = cmdData.fargs[1] or "codellama:7b-code"
    local buf = vim.api.nvim_get_current_buf()
    if cmdData.line1 == nil then
        vim.notify("This command requires a range")
    end
    local lines = vim.api.nvim_buf_get_lines(0, cmdData.line1 - 1, cmdData.line2, false)
    local json = vim.json.encode("<PRE> " .. table.concat(lines, "\n") .. " <MID>")
    vim.system({
        "curl",
        "http://192.168.0.114:11434/api/generate",
        "-d",
        '{"model": "' .. model .. '", "prompt": ' ..
        json .. '}'
    }, { text = true }, function(obj)
        local output_lines = vim.split(obj.stdout, "\n")
        vim.schedule(function()
            local result = ""
            for _, line in ipairs(output_lines) do
                if line == "" then
                    goto continue
                end
                local j = vim.json.decode(line)
                if j["response"] == nil then
                    goto continue
                end
                result = result .. j["response"]
                ::continue::
            end
            local split = vim.split(table.concat(lines, "\n"):gsub("<SUF>", result), "\n")
            vim.api.nvim_buf_set_lines(buf, cmdData.line1 - 1, cmdData.line2, false, split)
        end
        )
    end)
end

function OllamaDocument(cmdData)
    local model = cmdData.fargs[1] or "mistral"
    local buf = vim.api.nvim_get_current_buf()
    if cmdData.line1 == nil then
        vim.notify("This command requires a range")
    end
    local lines = vim.api.nvim_buf_get_lines(0, cmdData.line1 - 1, cmdData.line2, false)
    local json = vim.json.encode(table.concat(lines, "\n"))
    local commentstring = vim.api.nvim_get_option_value("commentstring", { buf = buf })
    vim.system({
        "curl",
        "http://localhost:11434/api/generate",
        "-d",
        '{"model": "' .. model .. '", "prompt": ' ..
        json ..
        ', "system": "You are an ai that creates markdown formatted documentation that describes what the function does and how to use it. Only provide documentation do not provide any further explanation or output, do not put the documentation in a code block. Provide a description of the function, its parameters, the return value, and example usage"}',
    }, { text = true }, function(obj)
        local output_lines = vim.split(obj.stdout, "\n")
        vim.schedule(function()
            local result = ""
            for _, line in ipairs(output_lines) do
                if line == "" then
                    goto continue
                end
                local j = vim.json.decode(line)
                if j["response"] == nil then
                    goto continue
                end
                result = result .. j["response"]
                ::continue::
            end
            local split = vim.split(result, "\n")
            for i, line in ipairs(split) do
                split[i] =  vim.fn.printf(commentstring, line)
            end
            vim.api.nvim_buf_set_lines(buf, cmdData.line1 - 2, cmdData.line1 - 1, false, split)
            -- local obuf = vim.api.nvim_create_buf(false, false)
            -- local width = vim.fn.winwidth(0)
            -- local height = vim.fn.winheight(0)
            -- local window = vim.api.nvim_open_win(obuf, true, {
            --     relative = "win",
            --     bufpos = {10, 5},
            --     width = width - 20,
            --     height = height - 10,
            --     border = "single",
            --     title = model .. " output",
            --     style = "minimal"
            -- })
            -- vim.api.nvim_buf_set_lines(obuf, 0, 1, false, vim.split(result, "\n"))
            -- vim.fn.setreg('"', result)
        end
        )
    end)
end

function GetLspNames ()
    local names = ""
    for _, lsp in ipairs(vim.lsp.get_clients()) do
        names = names .. lsp.name .. " "
    end
    if names ~= "" then
        return vim.trim("" .. names)
    end
    return ""
end

vim.api.nvim_create_user_command("X", function (data)
    local args = data.args
    local buf = vim.api.nvim_create_buf(true, false)
    vim.cmd.split()
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("term " .. args)
end, {nargs = "*"})

vim.api.nvim_create_user_command("OGen", OllamaGen, { range = true, nargs = "?" })
vim.api.nvim_create_user_command("ODocument", OllamaDocument, { range = true, nargs = "?" })
vim.api.nvim_create_user_command("EditSheet", EditSheet, {})
vim.api.nvim_create_user_command("Preview", PreviewFile, {})
vim.api.nvim_create_user_command("Exec", ExecSelection, { range = true, nargs = "?", bang = true })
vim.api.nvim_create_user_command("DisplayImg", DisplayImg, { nargs = "?" })
-- vim.api.nvim_create_user_command("ChatBotDocument", ChatBotDocument, { range = true })
vim.api.nvim_create_user_command("ChatBotComment", ChatBotComment, { range = true })
-- vim.api.nvim_create_user_command("ChatBotQuery", queryChatBot, {})
