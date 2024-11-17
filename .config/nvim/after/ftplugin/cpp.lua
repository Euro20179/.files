local ctrlO = vim.api.nvim_replace_termcodes("<c-o>", true, false, true)

vim.b.wraptry_catchWord = "}\rcatch(std::exception err){\r}" .. ctrlO .. ":if !search('^#include\\s*<exception>$', 'n') | call append(0, '#include <exception>') | endif\r"
