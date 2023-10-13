vim.bo.equalprg = "prettier --parser markdown"

if not vim.fn.execute("pwd"):match("Documents/vimwiki") then
    vim.wo.conceallevel = 0
end
