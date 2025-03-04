return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup({
      layouts = {
        {
          elements = {
            "scopes",
            -- 'breakpoints',
            "stacks",
            -- 'watches',
          },
          size = 50,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
