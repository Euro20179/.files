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

function GotoNthRelativeReference(n)
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2]

    local curBuf = vim.api.nvim_win_get_buf(0)
    local curFile = vim.fn.expand("%:p")

    vim.lsp.buf.references({
        includeDeclaration = true
    }, {
        on_list = function(items)
            local itemIdx, item = vim.iter(ipairs(items.items)):find(function(_, item)
                if not (item.bufnr == curBuf or item.filename == curFile) then
                    return false
                end

                if item.lnum < row then
                    return false
                end

                if item.lnum == row and item.col - 1 <= col then
                    return false
                end

                return true
            end)


            if itemIdx == nil then
                itemIdx = #items.items + 1
            end

            --itemIdx is actually the next item
            -- make it the pos in the list of the hovered item
            itemIdx = itemIdx - 1

            local importantReference = items.items[itemIdx + n]

            --wrap back around
            if importantReference == nil then
                    --from the top
                if n > 0 then
                    importantReference = items.items[n]
                else
                    -- from the bottom
                    importantReference = items.items[#items.items + 1 + n]
                end
            end

            -- the user selected an item with no references
            if importantReference == nil then
                return
            end

            vim.api.nvim_win_set_cursor(0, { importantReference.lnum, importantReference.col - 1 })
        end
    })
end

vim.api.nvim_create_user_command("Jumpreference", function (cmdData)
    GotoNthRelativeReference(tonumber(cmdData.args) or 1)
end, { nargs = "?" })

vim.api.nvim_create_user_command("EditSheet", EditSheet, {})
vim.api.nvim_create_user_command("Preview", PreviewFile, {})
-- vim.api.nvim_create_user_command("ChatBotDocument", ChatBotDocument, { range = true })
-- vim.api.nvim_create_user_command("ChatBotQuery", queryChatBot, {})
--

