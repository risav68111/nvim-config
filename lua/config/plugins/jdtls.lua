return {
  { "mfussenegger/nvim-jdtls" },
config = function() 
    vim.keymap.set("n", "<leader>gs", "<Cmd>lua require('jdtls').code_action()<CR>", { desc = "Generate Getters/Setters" })
    vim.keymap.set("n", "<leader>gc", "<Cmd>lua require('jdtls').code_action()<CR>", { desc = "Generate Constructor" })
    vim.keymap.set("n", "<leader>gt", "<Cmd>lua require('jdtls').code_action()<CR>", { desc = "Generate toString()" })
  end,
}
