function Rword()
    local words = {}
    for line in io.lines("/home/euro/Documents/words.txt") do
        words[#words + 1] = line
    end
    return words[math.random(1, #words)]
end

function EditSheet()
    local file = vim.api.nvim_buf_get_name(0)
    GotoTerminalBuf()
    vim.cmd.sleep("500ms")
    vim.api.nvim_feedkeys('i' .. "sheet " .. file .. "\n", "n", false)
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

function GetLspNames()
    local names = vim.iter(vim.lsp.get_clients()):map(function(c) return c.name end):join(" ")

    if names ~= "" then
        return vim.trim("" .. names)
    end

    return ""
end

function ListBufNames()
    return vim.iter(vim.api.nvim_list_bufs()):map(function(buf)
        return vim.api.nvim_buf_get_name(buf)
    end):filter(function(name) return name ~= "" end):totable()
end

vim.api.nvim_create_user_command("EditSheet", EditSheet, {})
-- vim.api.nvim_create_user_command("ChatBotDocument", ChatBotDocument, { range = true })
-- vim.api.nvim_create_user_command("ChatBotQuery", queryChatBot, {})
--
