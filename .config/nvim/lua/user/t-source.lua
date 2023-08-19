local source = {}

function source.new()
    return setmetatable({}, { __index = source})
end

function source:is_available()
    return true
end

function source:get_debug_name()
    return 'Time Source'
end

function source:get_keyword_pattern()
    return [[\k\+]]
end

function source:get_trigger_characters()
    return { "." }
end

function source:complete(params, callback)
    local input = string.sub(params.context.cursor_before_line, params.offset)
    local data = {
        { label = "timestamp", word = "" .. os.time(), kind = 12},
        { label = "January" },
        { label = "February" },
        { label = "March" },
        { label = "April" },
        { label = "May" },
        { label = "June" },
        { label = "July" },
        { label = "August" },
        { label = "September" },
        { label = "October" },
        { label = "November" },
        { label = "December" },
    }
    callback(data)
end

require("cmp").register_source("time", source.new())

