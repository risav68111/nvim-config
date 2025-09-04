return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- config = function()
  --   require("nvim-tree").setup({
  --     view = {
  --       width = 10,
  --       side = "left",
  --     },
  --     renderer = {
  --       highlight_git = true,
  --       icons = {
  --         show = {
  --           git = true,
  --           folder = true,
  --           file = true,
  --           folder_arrow = true,
  --         },
  --       },
  --     },
  --     update_focused_file = {
  --       enable = false, -- Already disabled, keeping for clarity
  --       update_cwd = false,
  --     },
  --     git = {
  --       enable = true,
  --     },
  --     actions = {
  --       open_file = {
  --         quit_on_open = false, -- Prevent NvimTree from closing on file open
  --         resize_window = false, -- Avoid resizing conflicts
  --       },
  --     },
  --     filters = {
  --       dotfiles = true, -- Optional: Include dotfiles for better visibility
  --     },
  --   })
  --   vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle NvimTree" })
  -- end,
}
