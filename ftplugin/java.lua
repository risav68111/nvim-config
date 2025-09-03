-- ftplugin/java.lua
local jdtls = require('jdtls')
local jdtls_setup = require('jdtls.setup')

-- Path to your Java installations (adjust these paths as needed)
local home = os.getenv('HOME')
local jdtls_path = home .. '/.local/share/nvim/mason/packages/jdtls'
local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local config_dir = jdtls_path .. '/config_linux' -- Change to 'config_win' or 'config_mac' based on your OS

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
        "/usr/lib/jvm/java-21-openjdk-amd64/bin/java",
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
            signatureHelp = { enabled = true },
            completion = {
                enabled = true,
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
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Keymaps for code actions and other LSP features
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts) -- Code actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })


        -- Add JDTLS-specific commands
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
