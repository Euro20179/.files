--[==[
Last Modified 12/19/2025 07:36
Description: jumps to the <n>th reference of an lsp symbol
--]==]
function GotoNthRelativeReference(n)
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    local col = pos[2]

    local curFile = vim.fn.expand("%:p")

    vim.lsp.buf.references({
        includeDeclaration = true
    }, {
        on_list = function(items)
            local relevantItems = vim.iter(items.items):filter(function(item)
                return item.filename == curFile
            end):totable()

            items.items = relevantItems

            local itemIdx, item = vim.iter(ipairs(relevantItems)):find(function(_, item)
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

vim.api.nvim_create_user_command("Jumpreference", function(cmdData)
    GotoNthRelativeReference(tonumber(cmdData.args) or 1)
end, { nargs = "?" })
