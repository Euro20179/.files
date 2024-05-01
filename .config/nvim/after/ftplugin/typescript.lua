-- local dap = require "dap"

-- local HOME = vim.fn.getenv("HOME")

vim.cmd.compiler("tsc")

-- require "dap-vscode-js".setup({
--     node_path = "node",
--     debugger_path = HOME .. "/Programs/vscode-js-debug",
--     adapters = { "pwa-node" }
-- })
--
-- for _, lang in ipairs({ "typescript", "javascript" }) do
--     dap.configurations[lang] = {
--         {
--             type = "pwa-node",
--             request = "launch",
--             name = "Launch File",
--             program = "${file}",
--             cwd = "${workspaceFolder}",
--             sourceMaps = false,
--             skipFiles = { "<node_interals>/**", "node_modules/*", "node_modules/", "node_modules/**", "node_modules/**/*" }
--         },
--         {
--             type = "pwa-node",
--             request = "attach",
--             name = "Attach",
--             processId = require "dap.utils".pick_process,
--             cwd = "${workspaceFolder}"
--         }
--     }
-- end
