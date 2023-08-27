require("symbols-outline").setup{
    position = "left",
    symbols = {
        Function = {icon = "", hl = "@function"},
        File = {icon = "", hl = "@text.uri"},
        Module = {icon = "", hl = "@namespace"},
        Class =  {icon = "", hl = "@type"},
        Method = {icon = " ", hl = "@method"},
        Property = {icon =  "", hl = "@method"},
        Field = {icon =  "", hl = "@field"},
        Constructor = {icon = "", hl = "@constructor"},
        Enum = {icon = "", hl = "@type"},
        Interface = {icon = "", hl = "@type"},
        Variable = {icon = "𝑥", hl = "@constant"},
        Constant = {icon = "", hl = "@constant"},
        EnumMember = {icon = "", hl = "@field"},
        Struct = {icon = "", hl = "@type"},
        Event = {icon = "", hl = "@type"},
        Operator = {icon = "", hl = "@operator"},
        TypeParameter ={icon =  "", hl = "@parameter"},
    },
    keymaps = {
        hover_symbol = "glh"
    }
}
