return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,               -- Clean exit from prompt
            },
          },
          layout_strategy = "horizontal",           -- Consistent layout to avoid window conflicts
          layout_config = {
            width = 0.8,
            height = 0.8,
          },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

      -- vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
      vim.keymap.set('n', '<leader>gf', function()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root == nil or git_root == "" or git_root:match("fatal") then
          vim.notify("🔒 Git not initialized in this directory", vim.log.levels.INFO,
            { title = "Telescope Git Files" })
          return
        end
        builtin.git_files()
      end, { desc = "Telescope Git Files (Safe)" })

      vim.keymap.set('n', '<leader>fws', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>fWs', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)

      vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = 'Telescope live definition' })


      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>bf', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
      vim.keymap.set('v', '<leader>fs', function()
        local text = vim.fn.getreg("v")
        require('telescope.builtin').grep_string({ search = text })
      end, { desc = "Search visual selection" })
    end
  }
}
