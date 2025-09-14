-- visual_scope.lua

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" }, -- │
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = { "Function", "Label" },
      },
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,            -- Show function/class name at top
      throttle = true,
      max_lines = 3,            -- Max lines of context to show
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',          -- Cursor-based context
      separator = nil,
    }
  }
}

