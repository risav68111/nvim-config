return {
  "risav68111/retain.nvim",
  -- dir = "C:\\Users\\risha\\Doc\\nvim-plugin\\retain.nvim",
  -- name = 'retain',
  -- lazy = false,
  config = function()
    local retain = require('retain')
    vim.keymap.set("n", "<leader>cd", function()
      retain.run()
    end, { desc = "Telescope CD Picker" })
    vim.keymap.set("n", "<leader>cdd", function()
      retain.delWin()
    end, { desc = "Telescope CD Picker" })
  end,
}
