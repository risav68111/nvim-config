local _lsp_float_active = false -- flag must be outside the return {}

local ensure_installed = {
  "vimdoc", "javascript", "typescript",
  "c", "lua", "rust", "jsdoc", "bash",
  "markdown", "markdown_inline", "regex", "comment",
  "python", "java", "xml", "go", "gomod",
  "yaml", "toml", "css", "html", "json",
  "sql", "qmljs", "asm", "gitignore", "hyprlang",
  "ini", "properties", "rasi", "desktop",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,

    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(ensure_installed)

      vim.treesitter.query.set("markdown", "injections", "")
      vim.treesitter.query.set("markdown_inline", "injections", "")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if _lsp_float_active then return end

          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then return end

          if not vim.treesitter.language.add(lang) then
            if vim.list_contains(require("nvim-treesitter").get_available(), lang) then
              require("nvim-treesitter").install(lang):wait(60000)
            end
            if not vim.treesitter.language.add(lang) then return end
          end

          vim.treesitter.start(buf, lang)
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
