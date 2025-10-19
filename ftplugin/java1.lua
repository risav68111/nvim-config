

--[[
local M = {}
local path_to_java_dap = "~/dap/java-debug/com.microsoft.java.debug.plugin/target/";

function M.setup()
    require("lazy").setup({
        {
            "mfussenegger/nvim-jdtls",
            ft = { "java" },
            config = function()
                local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                local home = os.getenv("HOME")
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
                        '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',

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
                    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),

                    -- Here you can configure eclipse.jdt.ls specific settings
                    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                    -- for a list of options
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
                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(bufnr, true)
                    end
                end
                local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
                extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
                extendedClientCapabilities.generateToStringPromptSupport = true
                extendedClientCapabilities.hashCodeEqualsPromptSupport = true
                extendedClientCapabilities.methodGeneration = true

                jdtls_config.init_options = {
                    extendedClientCapabilities = extendedClientCapabilities
                }
vim.keymap.set("n", "<leader>to", require("jdtls").generate_toString)
vim.keymap.set("n", "<leader>eq", require("jdtls").generate_equals_and_hash_code)
vim.keymap.set("n", "<leader>gs", require("jdtls").generate_constructor)


                -- This starts a new client & server,
                -- or attaches to an existing client & server depending on the `root_dir`.
                require("jdtls").start_or_attach(config)
            end,
        },
    })
end

--]]
