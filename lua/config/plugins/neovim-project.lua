return {
  "coffebar/neovim-project",
  opts = {
    -- Project directories to track
    projects = {
      "~/projects/*",
      "~/p*cts/*",
      "~/projects/repos/*",
      "~/.config/*",
      "~/work/*",
    },
    -- Where to store sessions and history
    datapath = vim.fn.stdpath("data"), -- ~/.local/share/nvim/
    
    -- Auto-load last session if not inside a project
    last_session_on_startup = true,

    -- Dashboard mode: disable session loading
    dashboard_mode = false,

    -- Timeout before triggering FileType autocmd (after session load)
    filetype_autocmd_timeout = 200,

    -- Key mappings to delete a project from history in Telescope picker
    forget_project_keys = {
      i = "<C-d>", -- insert mode
      n = "d",     -- normal mode
    },

    -- Handling symbolic links
    follow_symlinks = "full", -- follow symlinks fully

    -- Session Manager options override
    session_manager_opts = {
      autosave_ignore_dirs = {
        vim.fn.expand("~"), -- ignore home directory
        "/tmp",
      },
      autosave_ignore_filetypes = {
        "ccc-ui",
        "gitcommit",
        "gitrebase",
        "qf",
        "toggleterm",
      },
    },

    -- Picker settings
    picker = {
      type = "telescope", -- use telescope for project picking
      preview = {
        enabled = true,      -- show directory structure
        git_status = true,   -- show git info
        git_fetch = false,   -- don't fetch remote
        show_hidden = true,  -- show hidden files
      },
      opts = {
        -- You can pass additional Telescope picker options here if needed
      },
    },
  },

  init = function()
    -- Save globals in sessions (very useful for many plugins)
    vim.opt.sessionoptions:append("globals")
  end,

  dependencies = {
    { "nvim-lua/plenary.nvim" }, -- required
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" }, -- picker (optional but recommended)
    { "ibhagwan/fzf-lua" }, -- alternative picker (optional)
    { "Shatur/neovim-session-manager" }, -- session management
  },

  lazy = false, -- load immediately
  priority = 100, -- load early
}

