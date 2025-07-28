return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    dap.adapters["pwa-node"] = {
      type = "executable",
      host = "127.0.0.1",
    }

    dap.adapters.node = {
      type = "executable",
      host = "127.0.0.1",
    }

    dap.adapters.lldb = {
      type = "executable",
      command = "/opt/homebrew/bin/lldb-vscode", -- adjust as needed
      name = "lldb",
      host = "127.0.0.1",
    }

    dap.configurations.rust = {
      {
        name = "hello-world",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.getcwd() .. "/target/debug/hello-world"
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        name = "hello-dap",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.getcwd() .. "/target/debug/hello-dap"
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  end,
}
