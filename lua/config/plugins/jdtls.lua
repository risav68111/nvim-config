return {
  "mfussenegger/nvim-jdtls",
  config = function()
    local jdtls = require("jdtls")

    -- Generate Getters and Setters
    vim.keymap.set("n", "<leader>gs", function()
      jdtls.code_action({ command = "java.apply.workspaceEdit", title = "Generate Getters/Setters" })
    end, { desc = "Generate Getters/Setters" })

    -- Generate Constructor
    vim.keymap.set("n", "<leader>gc", function()
      jdtls.code_action({ command = "java.apply.workspaceEdit", title = "Generate Constructor" })
    end, { desc = "Generate Constructor" })

    -- Generate toString() Method
    vim.keymap.set("n", "<leader>gt", function()
      jdtls.code_action({ command = "java.apply.workspaceEdit", title = "Generate toString()" })
    end, { desc = "Generate toString()" })
  end,
}
