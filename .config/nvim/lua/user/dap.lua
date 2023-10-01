local dap = require"dap"

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
