return {
  "rcarriga/nvim-notify",
  lazy = false,
  config = function()
    local notify = require("notify")

    notify.setup({
      stages = "fade",      -- animation style
      timeout = 600,       -- how long to show
      max_width = 100,       -- ✅ reduce width of the notification window
      max_height = function()
        return math.floor(vim.o.lines * 0.2) -- ✅ max 20% of screen height
      end,
      render = "default",   -- "minimal" also works
      background_colour = "#000000", -- optional
    })

    vim.notify = notify
  end,
}

