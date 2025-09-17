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

      -- Custom background only for Neo-tree
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#13110a" }) -- 1e1e2e
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "#13110a" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#13110a" })

      vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" }) --Toggle
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
