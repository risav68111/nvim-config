return {
  'mfussenegger/nvim-jdtls',
  config = function()
    local jdtls = require('jdtls')

    -- Keymaps
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
  end
}

