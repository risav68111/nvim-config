local M = {}
local path_to_java_dap = "~/dap/java-debug/com.microsoft.java.debug.plugin/target/";

function M.setup()
    require("lazy").setup({
        {
            "mfussenegger/nvim-jdtls",
            ft = { "java" },
            config = function()
                local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                local workspace_dir = "~/nvim-jdtls/workspace/" .. project_name
                local config = {
                    -- The command that starts the language server
                    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                    cmd = {

                        -- 💀
                        "/usr/lib/jvm/java-21-openjdk-amd64/bin/java", -- or '/path/to/java17_or_newer/bin/java'
                        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

                        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                        "-Dosgi.bundles.defaultStartLevel=4",
                        "-Declipse.product=org.eclipse.jdt.ls.core.product",
                        "-Dlog.protocol=true",
                        "-Dlog.level=ALL",
                        "-Xmx1g",
                        "--add-modules=ALL-SYSTEM",
                        "--add-opens",
                        "java.base/java.util=ALL-UNNAMED",
                        "--add-opens",
                        "java.base/java.lang=ALL-UNNAMED",

                        -- 💀
                        "-jar",
                        "~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar",
                        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
                        -- Must point to the                                                     Change this to
                        -- eclipse.jdt.ls installation                                           the actual version

                        -- 💀
                        "-configuration",
                        "~/.local/share/nvim/mason/packages/jdtls/config_linux",
                        -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                        -- Must point to the                      Change to one of `linux`, `win` or `mac`
                        -- eclipse.jdt.ls installation            Depending on your system.

                        -- 💀
                        -- See `data directory configuration` section in the README
                        "-data",
                        workspace_dir,
                    },

                    -- 💀
                    -- This is the default if not provided, you can remove it. Or adjust as needed.
                    -- One dedicated LSP server & client will be started per unique root_dir
                    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

                    -- Here you can configure eclipse.jdt.ls specific settings
                    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                    -- for a list of options
                    settings = {
                        java = {},
                    },

                    -- Language server `initi::alizationOptions`
                    -- You need to extend the `bundles` with paths to jar files
                    -- if you want to use additional eclipse.jdt.ls plugins.
                    --
                    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
                    --
                    init_options = {
                        bundles = {
                            vim.fn.glob(path_to_java_dap .. "com.microsoft.java.debug.plugin-0.53.2.jar", 1)
                        },
                    },
                }

                config['on_attach'] = function(client, bufnr)
                    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
                end


                -- This starts a new client & server,
                -- or attaches to an existing client & server depending on the `root_dir`.
                require("jdtls").start_or_attach(config)
            end,
        },
    })
end

--[[
local home = os.getenv("HOME")
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, 'jdtls')
if not status then
    print("no jdtls")
    return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
    cmd = {
        '/usr/lib/jvm/java-21-openjdk-amd64/bin/java', -- assumes `java` is in your PATH
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
        '-jar',
        vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration',
        home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
        '-data',
        workspace_dir,
    },

    root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
            maven = { downloadSources = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            inlayHints = {
                parameterNames = {
                    enabled = 'all',
                },
            },
            format = {
                enabled = true,
            },
        },
    },

    init_options = {
        bundles = {},
    },

    on_attach = function(client, bufnr)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(bufnr, true)
        end
    end,

    capabilities = {
        workspace = {
            configuration = true,
        },
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    },
}

require('jdtls').start_or_attach(config)

vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
    { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
    { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })
--]]
