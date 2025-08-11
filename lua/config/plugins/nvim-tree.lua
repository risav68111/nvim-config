return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      git = {
        enable = true,
      },
    })

    -- Set keymap to toggle with Ctrl + b
    vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle NvimTree" })
  end,
}

