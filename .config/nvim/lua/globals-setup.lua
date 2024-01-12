vim.fn.setenv("IN_VIM", "true")

vim.fn.setenv("NVIM", vim.v.servername)

vim.g._outline_cmd = "SymbolsOutline"

vim.diagnostic.config({ virtual_text = true })

---@diagnostic disable-next-line
vim.ui.open = function(item)
    vim.system({ "linkhandler", item })
end

vim.fn.setcellwidths({
    { 0xe5fa, 0xe6ac, 2 },
    { 0xea60, 0xebeb, 2 },
    { 0xe000, 0xe00a, 2 },
    { 0xf300, 0xf32f, 2 },
    { 0x23fb, 0x23fe, 2 },
    { 0x2b58, 0x2b58, 2 },
    { 0xe0a3, 0xe0a3, 2 },
    { 0xe0b4, 0xe0c8, 2 },
    { 0xe0ca, 0xe0ca, 2 },
    { 0xe0cc, 0xe0d4, 2 },
    { 0xe0a0, 0xe0a2, 2 },
    { 0xe0b0, 0xe0b3, 2 },
    { 0xf400, 0xf532, 2 },
    { 0x2665, 0x26A1, 2 },
    { 0xe300, 0xe3e3, 2 },
    -- { 0xf0001, 0xf1af0, 2 }, conflicts with 'fillchars'
    { 0xe200, 0xe2a9, 2 },
    { 0xf000, 0xf2e0, 2 },
    { 0xe700, 0xe7c5, 2 }
})
