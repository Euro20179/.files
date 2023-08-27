local json = require("lib.json")

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

local function queryChatBot(data)
    str = vim.ui.input({ prompt = "Query: " }, function(input)
        if input ~= nil then
            local filename = "/tmp/nvim-ChatBotQuery"
            local f = io.open(filename, "w")
            input = json.encode(input)
            if f then
                f:write(input)
                f:close()
            end
            local handle = io.popen([[
        curl -s "https://api.openai.com/v1/completions" \
             -H 'Content-Type: application/json' \
             -H "Authorization: Bearer $(cat ~/Documents/APIKeys/openai.private)" \
             -d '{"model": "text-davinci-003", "prompt": '"$(cat ]] ..
                filename .. [[)"', "temperature": 0}' | jq -r '.choices[0].text'
    ]]       )
            if handle then
                local res = handle:read("*a")
                vim.api.nvim_put(vim.split(res, "\n"), "l", true, true)
            end
            os.remove(filename)
        end
    end)
end

local function _chatbotmain(data, type)
    if data.line1 == nil then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, data.line1 - 1, data.line2, false)
    local str = ""
    for i, line in ipairs(lines) do
        str = str .. line .. '\n'
    end
    str = json.encode(str)
    local filename = "/tmp/nvim-ChatBot"
    local f = io.open(filename, "w")
    if f then
        f:write(str)
        f:close()
    end
    local handle = io.popen([[
        curl -s "https://api.openai.com/v1/edits" \
             -H 'Content-Type: application/json' \
             -H "Authorization: Bearer $(cat ~/Documents/APIKeys/openai.private)" \
             -d '{"model": "text-davinci-edit-001", "input": '"$(cat ]] ..
        filename .. [[)"', "instruction": "]] .. type .. [[", "temperature": 0}' | jq -r '.choices[0].text'
    ]])
    if handle then
        local res = handle:read("*a")
        -- print(res)
        vim.api.nvim_buf_set_lines(0, data.line1 - 1, data.line2, false, vim.split(res, "\n"))
        handle:close()
    end
    os.remove(filename)
end

function ChatBotComment(data)
    _chatbotmain(data, "Add comments")
end

function ChatBotDocument(data)
    _chatbotmain(data, "Add documentation")
end

vim.api.nvim_create_user_command("ChatBotDocument", ChatBotDocument, { range = true })
vim.api.nvim_create_user_command("ChatBotComment", ChatBotComment, { range = true })
vim.api.nvim_create_user_command("ChatBotQuery", queryChatBot, {})
