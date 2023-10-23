local dap = require "dap"


local HOME = vim.fn.getenv("HOME")

-- dap.adapters.rust = {
--     type = 'executable',
--     attach = { pidProperty = "pid", pidSelect = "ask" },
--     command = "codelldb",
--     env = {LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"},
--     name = "lldb"
-- }

--dap.adapters.rust = dap.adapters.codelldb

-- dap.configurations.rust = {
--     {
--         name = "Rust debug",
--         type = "rust",
--         request = "launch",
--         program = function()
--             local metadata_json = vim.fn.system "cargo metadata --format-version 1 --no-deps"
--             local metadata = vim.fn.json_decode(metadata_json)
--             local target_name = metadata.packages[1].targets[1].name
--             local target_dir = metadata.target_directory
--             return target_dir .. "/debug/" .. target_name
--         end,
--         args = function()
--             local inputstr = vim.fn.input("Params: ", "")
--             local params = {}
--             local sep = "%s"
--             for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
--                 table.insert(params, str)
--             end
--             return params
--         end
--     },
-- }

dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { '-m', 'debugpy.adapter' }
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch File",
        program = "${file}",
        pythonPath = function() return "/usr/bin/python" end,
        justMyCode = "false"
    }
}

dap.adapters.sh = {
    type = "executable",
    command = HOME .. "/.local/share/nvim/mason/bin/bash-debug-adapter"
}

dap.configurations.sh = {
    {
        type = "sh",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${fileDirname}",
        args = {},
        env = {},
        pathBash = "bash",
        pathCat = "cat",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        pathBashdb = HOME .. "/.local/share/nvim/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
        pathBashdbLib = HOME .. "/.local/share/nvim/mason/packages/bash-debug-adapter/extension/bashdb_dir"
    }
}

require "dap-vscode-js".setup({
    node_path = "node",
    debugger_path = HOME .. "/Programs/vscode-js-debug",
    adapters = { "pwa-node" }
})

for _, lang in ipairs({ "typescript", "javascript" }) do
    dap.configurations[lang] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch File",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = false,
            skipFiles = { "<node_interals>/**", "node_modules/*", "node_modules/", "node_modules/**", "node_modules/**/*" }
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require "dap.utils".pick_process,
            cwd = "${workspaceFolder}"
        }
    }
end
