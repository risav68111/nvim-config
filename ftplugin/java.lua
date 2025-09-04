-- ftplugin/java.lua
local status, jdtls = pcall(require, "jdtls")
-- if not status then
--   return
-- end
local jdtls_setup = require('jdtls.setup')
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Path to your Java installations (adjust these paths as needed)
local home = os.getenv('HOME')
local mason_path = home .. "/.local/share/lvim/mason/"
local jdtls_path = mason_path .. "packages/jdtls"
local plugins_dir = jdtls_path .. '/plugins/'
local launcher_jar = vim.fn.glob(plugins_dir .. '/org.eclipse.equinox.launcher_*.jar')
-- 'org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar'
local config_dir = jdtls_path .. '/config_linux' -- Change to 'config_win' or 'config_mac' based on your OS

local jdk_java = "/usr/lib/jvm/java-21-openjdk-amd64/bin/java"

-- Workspace directory for JDTLS data (unique per project)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

-- Root markers to detect Java projects
local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = jdtls_setup.find_root(root_markers)

-- Extended client capabilities for advanced code actions
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.advancedGenerateAccessorsSupport = true
extendedClientCapabilities.advancedGenerateToStringSupport = true -- Enable toString code action

-- JDTLS configuration
local config = {
  cmd = {
    jdk_java,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
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
      eclipse = {
        downloadSources = true,
      },
      signatureHelp = { enabled = true },
      completion = {
        enabled = true,
        favoriteStaticMembers = {
          'org.junit.Assert.*',
          'org.junit.Assume.*',
          'java.util.Objects.*',
          'java.util.stream.Collectors.*',
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
          "org.springframework.*"
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org"
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      gradle = {
        gradle = {
          enabled = true,
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
        enabled = true,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
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
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          --[[
                    {
                        name = 'JavaSE-1.8',
                        path = '/path/to/java-8', -- Adjust to your Java 8 path
                        default = true,
                    },
                    {
                        name = 'JavaSE-17',
                        path = '/path/to/java-17', -- Adjust to your Java 17 path
                    },
                    --]]
        },
      },
    },
  },
  init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
  },
  on_attach = function(client, bufnr)
    -- Enable completion
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- General LSP mappings
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- JDTLS-specific mappings
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- generic code actions
    vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, opts)
    vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, opts)
    vim.keymap.set('v', '<leader>em', [[<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>]], opts)
    vim.keymap.set('n', '<leader>ec', jdtls.extract_constant, opts)

    -- Add JDTLS commands
    jdtls.setup.add_commands()
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

-- Start or attach the JDTLS server
jdtls.start_or_attach(config)

-- Autocommand to ensure JDTLS attaches on FileType java
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'java',
--     callback = function()
--         jdtls.start_or_attach(config)
--     end,
-- })
