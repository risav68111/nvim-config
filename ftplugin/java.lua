local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

local java_cmd = vim.fn.exepath("java")
local java_home = vim.fn.fnamemodify(java_cmd, ":h:h")

local home = os.getenv('HOME')
local mason_path = home .. "/.local/share/nvim/mason/"
local jdtls_path = mason_path .. "packages/jdtls"

local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", 1)
local config_dir = jdtls_path .. '/config_linux'

local function find_lombok_jar()
  local cached = vim.fn.glob(
    home .. '/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/*/*/lombok-*.jar', 1, 1)
  local m2 = vim.fn.glob(home .. '/.m2/repository/org/projectlombok/lombok/*/lombok-*.jar', 1, 1)
  vim.list_extend(cached, m2)
  if #cached > 0 then
    table.sort(cached)
    return cached[#cached]
  end
  return jdtls_path .. '/lombok.jar'
end

local lombok_jar = find_lombok_jar()

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = jdtls_setup.find_root(root_markers)
if not root_dir then return end

local workspace_dir = home .. '/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(bundles, vim.split(
  vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n"
))

local extended = jdtls.extendedClientCapabilities
extended.resolveAdditionalTextEditsSupport = true
extended.advancedGenerateAccessorsSupport = true
extended.advancedGenerateToStringSupport = true

vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

local config = {
  single_file_support = false,
  cmd = {
    java_cmd,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms512m',
    '-Xmx2g',
    '-javaagent:' .. lombok_jar,
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-configuration', config_dir,
    '-data', workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      signatureHelp = { enabled = true },
      imports = {
        gradle = {
          wrapper = {
            checksums = {
              { sha256 = '7a9ce74cff467ca1bf60a4fcd9f05185acceda4d0f382434d393e17864262c5d', allowed = true },
            },
          },
        },
      },
      completion = {
        favoriteStaticMembers = {
          'org.junit.Assert.*',
          'org.junit.Assume.*',
          'java.util.Objects.*',
          'java.util.stream.Collectors.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
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
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
    },
    configuration = {
      runtimes = {
        { name = "JavaSE-21", path = java_home, default = true },
      },
    },
  },

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extended,
  },

  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rf', vim.lsp.buf.rename, opts)

    vim.keymap.set('n', 'K', function()
      local d = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
      if #d > 0 then
        vim.diagnostic.open_float(nil, { border = "rounded" })
      else
        vim.lsp.buf.hover({ border = "rounded" })
      end
    end, opts)

    jdtls.setup.add_commands()
    jdtls.setup_dap({ hotcodereplace = "auto" })

    if jdtls.dap then
      vim.keymap.set('n', '<leader>dt', jdtls.dap.test_class, opts)
      vim.keymap.set('n', '<leader>dT', jdtls.dap.test_nearest_method, opts)
      vim.keymap.set('n', '<leader>dc', jdtls.dap.run_config, opts)
    end
  end,

  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

jdtls.start_or_attach(config)
