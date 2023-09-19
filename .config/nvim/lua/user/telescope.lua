local pickers = require "telescope.pickers"

local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local getGitTags = function()
    local tags = {}
    for line in io.popen("[ -d .git ] && { git tag | tac; }", "r"):lines() do
        tags[#tags + 1] = line
    end
    return tags
end

local telescope_diff = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_cmd({cmd = "new"}, {})
                vim.api.nvim_cmd({cmd = "wincmd", args = {"j"}}, {})
                vim.cmd([[read !git diff ]] .. selection[1])
                vim.o.filetype = "diff"
            end)
            return true
        end,
        prompt_title = "colors",
        finder = finders.new_table {
            results = getGitTags()
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

-- local ytfzf_previewer = require("telescope.previewers").Previewer:new{
--     setup = function(self) end,
--     teardown = function (self) end,
--     preview_fn = function(self, entry, status)
--         return entry
--     end,
--     title = function (self)
--         return "Thumbnail"
--     end,
--     dynamic_title = function (self, entry)
--         return entry
--     end
-- }
--
local ytfzf = function(opts)
    opts = opts or {}
    local _on_done = opts._on_done
    pickers.new(opts, {
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if _on_done then
                    _on_done(selection)
                end
            end)
            return true
        end,
        prompt_title = "ytfzf",
        finder = finders.new_table {
            results = (function ()
                local final_text = {}
                vim.ui.input({ prompt = "Search: " }, function (text)
                    if text then
                        vim.g._NVIM_YTFZF = ""
                        vim.api.nvim_cmd({cmd = "redir", args = {"=>", "g:_NVIM_YTFZF"}}, {})
                        vim.cmd([[filter /|/ !YTFZF_CONFIG_FILE="/dev/null" ytfzf -A -IR ]] .. text)
                        vim.api.nvim_cmd({cmd = "redir", args = {"END"}}, {})
                        local t = vim.split(vim.g._NVIM_YTFZF, "\n")
                        for _, value in ipairs(t) do
                            if string.match(value, "|") then
                                final_text[#final_text+1] = value
                            end

                        end
                    end
                end)
                while not final_text[1] do
                    vim.uv.sleep(1)
                end
                return final_text
            end)()
        },
        sorter = conf.generic_sorter(opts)
    }):find()
end

return {
    telescope_diff = telescope_diff,
    get_git_tags = getGitTags,
    telescope_ytfzf = ytfzf,
}
