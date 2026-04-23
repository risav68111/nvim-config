local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

-- JAVA HOME (Windows)
local java_path = "C:/Java/jdk-21" -- my java dir <-- change this according to your dir

-- Mason/JDTLS paths
local home = os.getenv("USERPROFILE")
local mason_path = home .. "/AppData/Local/nvim-data/mason/"
local jdtls_path = mason_path .. "/packages/jdtls"

-- Launcher JAR
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Platform config dir
local config_dir = jdtls_path .. "/config_win"

-- Workspace
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/jdtls-workspaces/" .. project_name

-- Root directory
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = jdtls_setup.find_root(root_markers)

-- Bundles
local bundles = {}

vim.list_extend(bundles, vim.split(
  vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"
))

vim.list_extend(bundles, vim.split(
  vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n"
))

-- Extended capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.advancedGenerateAccessorsSupport = true
extendedClientCapabilities.advancedGenerateToStringSupport = true

-- Java indentation
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Windows JDTLS cmd
local config = {
  cmd = {
    java_path .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",

    -- Lombok
    "-javaagent:" .. jdtls_path .. "/lombok.jar",

    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        enabled = true,
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "java.util.Objects.*",
          "java.util.stream.Collectors.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },

      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },

      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },

    configuration = {
      runtimes = {
        {
          name = "JavaSE-21",
          path = java_path,
          default = true,
        },
      },
    },
  },

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },

  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

    vim.keymap.set("n", "K", function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
      if #diagnostics > 0 then
        vim.diagnostic.open_float(nil, {
          focus = false,
          border = "rounded",
          padding = { 4, 6, 4, 6 },
        })
      else
        vim.lsp.buf.hover({
          border = "rounded",
          padding = { 4, 6, 4, 6 },
        })
      end
    end)

    jdtls.setup.add_commands()

    vim.defer_fn(function()
      print("=== JDTLS DAP DEBUG ===")
      print("jdtls type:", type(jdtls))
      print("jdtls.setup_dap available:", jdtls.setup_dap ~= nil)

      if jdtls.setup_dap then
        print("Calling setup_dap...")
        jdtls.setup_dap({ hotcodereplace = "auto" })

        if jdtls.dap then
          print("DAP loaded:", vim.inspect(vim.tbl_keys(jdtls.dap)))
          vim.keymap.set("n", "<leader>dt", jdtls.dap.test_class, bufopts)
          vim.keymap.set("n", "<leader>dT", jdtls.dap.test_nearest_method, bufopts)
          vim.keymap.set("n", "<leader>dc", jdtls.dap.run_config, bufopts)
          vim.notify("JDTLS DAP setup successful")
        else
          print("ERROR: jdtls.dap is NIL after setup_dap")
        end
      else
        print("ERROR: jdtls.setup_dap not found")
      end
    end, 1000)
  end,

  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}


jdtls.start_or_attach(config)



-- Autocommand to ensure JDTLS attaches on FileType java
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'java',
--     callback = function()
--         jdtls.start_or_attach(config)
--     end,
-- })
