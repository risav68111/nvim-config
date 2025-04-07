return {
  'mfussenegger/nvim-jdtls',
  config = function()
    local jdtls = require('jdtls')

    -- Get Windows username home path
    local home = os.getenv('USERPROFILE')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = home .. '\\AppData\\Local\\nvim-data\\jdtls-workspace\\' .. project_name

    local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
    local root_dir = require('jdtls.setup').find_root(root_markers)

    if root_dir == nil then
      print("Java LSP: Could not find project root.")
      return
    end

    local jdtls_path = 'C:\\Users\\risha\\AppData\\Local\\nvim-data\\mason\\bin\\jdtls.cmd' -- Change to full path if needed, e.g., 'C:\\tools\\jdtls\\bin\\jdtls.bat'

    local config = {
      cmd = {
        jdtls_path,
        '-data', workspace_dir
      },
      root_dir = root_dir,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = "interactive",
          },
        },
      },
      init_options = {
        bundles = {},
      }
    }

    jdtls.start_or_attach(config)

    -- Keymaps
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
    vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, { desc = 'Organize Imports' })
    vim.keymap.set('n', '<leader>rf', vim.lsp.buf.rename, { desc = 'Rename Symbol' })
  end
}

