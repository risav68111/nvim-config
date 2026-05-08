return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    -- commit = "90cd658",
    opts = {
      ensure_installed = {
        "vimdoc", "javascript", "typescript",
        "c", "lua", "rust", "jsdoc", "bash",
        "markdown", "markdown_inline",
      },

      sync_install = false,
      auto_install = true,

      indent = {
        enable = true,
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      vim.treesitter.language.register("templ", "templ")

      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function(args)
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then return end
            for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
              if vim.api.nvim_win_is_valid(win)
                  and vim.api.nvim_win_get_config(win).relative ~= "" then
                pcall(vim.treesitter.stop, args.buf)
                return
              end
            end
          end)
        end,
      })
    end,
  },
}
