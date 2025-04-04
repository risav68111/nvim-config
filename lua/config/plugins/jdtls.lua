return {
  "mfussenegger/nvim-jdtls",
  config = function()
    local jdtls = require("jdtls")

    -- Generate Getters and Setters
    vim.keymap.set("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, { desc = " all code action option " })
  end,
}

