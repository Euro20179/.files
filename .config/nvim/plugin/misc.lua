--[==[
Last Modified 12/19/2025 07:37
Description: miscellanious helper functions to be called in the ex cmdline
or a keybind
--]==]
function Rword()
    local words = {}
    for line in io.lines("/home/euro/Documents/words.txt") do
        words[#words + 1] = line
    end
    return words[math.random(1, #words)]
end

function Word_count()
    local text = vim.fn.join(vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {}), "\n")
    local count = vim.iter(vim.split(text, "%s")):filter(function(w)
        return w ~= ""
    end):enumerate():last()
    return count[1]
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
