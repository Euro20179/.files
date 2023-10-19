local dap = require"dap"

local HOME = vim.fn.getenv("HOME")

dap.adapters.python = {
    type = "executable",
    command = "/usr/bin/python",
    args = { '-m', 'debugpy.adapter'}
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch File",
        program = "${file}",
        pythonPath = function() return "/usr/bin/python" end
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
