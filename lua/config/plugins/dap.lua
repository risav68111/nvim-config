-- lua/config/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Keymaps
      vim.keymap.set("n", "<F4>", dap.toggle_breakpoint)
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<S-F11>", dap.step_out)
      vim.keymap.set("n", "<leader>dx", dap.terminate)
      vim.keymap.set("n", "<leader>du", dapui.toggle)
    end,
  },
}


-- return {
--     "mfussenegger/nvim-dap",
--     dependencies = {
--         -- ui plugins to make debugging simplier
--         "rcarriga/nvim-dap-ui",
--         "nvim-neotest/nvim-nio"
--     },
--     config = function()
--         -- gain access to the dap plugin and its functions
--         local dap = require("dap")
--         -- gain access to the dap ui plugin and its functions
--         local dapui = require("dapui")
--
--         -- Setup the dap ui with default configuration
--         dapui.setup()
--
--          -- setup an event listener for when the debugger is launched
--         dap.listeners.before.launch.dapui_config = function()
--             -- when the debugger is launched open up the debug ui
--             dapui.open()
--         end
--
--         -- set a vim motion for <Space> + d + t to toggle a breakpoint at the line where the cursor is currently on
--         vim.keymap.set("n", "<F4>", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint" })
--
--         -- set a vim motion for <Space> + d + s to start the debugger and launch the debugging ui
--         vim.keymap.set("n", "<F5>", dap.continue, { desc = "[D]ebug [S]tart" })
--
--         -- set a vim motion to close the debugging ui
--         vim.keymap.set("n", "<S-F5>", dapui.close, {desc = "[D]ebug [C]lose"})
--     end
-- }
