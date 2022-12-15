require"dap-vscode-js".setup{
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost"}
}

for _, lang in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[lang] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require"dap.utils".pick_process,
            cwd = "${workspaceFolder}",
        }
    }
end
