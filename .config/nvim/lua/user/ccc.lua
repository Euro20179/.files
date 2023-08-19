local ccc = require("ccc")

local mapping = ccc.mapping
ccc.setup{
    inputs = {
        ccc.input.hsl,
        ccc.input.rgb
    },
    highlighter = {
        auto_enable = true
    },
    mappings = {
        ["$"] = mapping.set100
    }
}

