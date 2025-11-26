return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          -- Do not auto-open/close Neo-tree
          follow_current_file = { enabled = false },
          hijack_netrw_behavior = "disabled", -- don't replace netrw
        },
        event_handlers = {
          -- Remove auto-open on VimEnter
        },
        window = {
          mappings = {
            ["o"] = {
              "open",
              config = {
                open_split = "vertical",
                position = "left",
              },
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}

