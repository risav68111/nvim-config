return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    -- formatter
    require("conform").setup({})

    -- cmp capabilities
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- ui
    require("fidget").setup({})
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "emmet_ls",
        "gopls",
        "html",
        "zls",
      },
    })

    -- auto setup installed servers
    for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
      if server ~= "jdtls" then
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end

    -- overrides

    vim.lsp.config("html", {
      capabilities = capabilities,
      filetypes = { "html", "templ" },
    })
    vim.lsp.enable("html")

    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
      filetypes = { "html", "css", "javascriptreact" },
    })
    vim.lsp.enable("emmet_ls")

    vim.lsp.config("zls", {
      capabilities = capabilities,
      root_dir = vim.fs.root(0, { ".git", "build.zig", "zls.json" }),
      settings = {
        zls = {
          enable_inlay_hints = true,
          enable_snippets = true,
          warn_style = true,
        },
      },
    })
    vim.lsp.enable("zls")

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("gopls", {
      capabilities = capabilities,
      cmd = { "gopls" },
      filetypes = { "go", "gomod" },
      root_dir = vim.fs.root(0, { "go.mod", ".git" }),
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            nilness = true,
            unusedwrite = true,
          },
          staticcheck = true,
        },
      },
    })
    vim.lsp.enable("gopls")

    -- snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- cmp
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
    })
    -- cmdline completion for `:`
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- optional: also restore `/` search completion
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })


    -- diagnostics
    vim.diagnostic.config({
      float = {
        focusable = false,
        border = "rounded",
        source = "always",
      },
    })

    -- keymaps (FIXED)
    vim.keymap.set("n", "<leader>rf", vim.lsp.buf.rename)

    vim.keymap.set("n", "K", function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
      if #diagnostics > 0 then
        vim.diagnostic.open_float(nil, {
          focus = false,
          border = "rounded",
        })
      else
        vim.lsp.buf.hover({
          border = "rounded",
        })
      end
    end, { silent = true })
  end,
}
