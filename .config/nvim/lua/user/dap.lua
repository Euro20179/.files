local dap = require "dap"


local HOME = vim.fn.getenv("HOME")

dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { '-m', 'debugpy.adapter' }
}

dap.adapters.lldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "/home/euro/.local/share/nvim/mason/bin/codelldb",
        args = { "--port", "${port}" }
    }
}

dap.configurations.c = {
    {
        type = "lldb",
        request = "launch",
        program = "./a.out",
        cwd = "${workspaceFolder}",
        enableTelemetry = false,
        stopOnEntry = false
    }
}

dap.configurations.rust = {
    {
        type = "lldb",
        request = "launch",
        program = function ()
            return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.input("filename: ")
        end,
        cwd = '${workspaceFolder}',
        enableTelemetry = false,
        stopOnEntry = false
    }
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
