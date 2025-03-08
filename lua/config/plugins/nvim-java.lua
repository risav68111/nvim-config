return {
    {
        "nvim-java/nvim-java",
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("java").setup()
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").jdtls.setup({
                cmd = { "jdtls" }, -- Ensure jdtls is installed
                root_dir = require("lspconfig").util.root_pattern("pom.xml", "build.gradle", ".git"),
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        contentProvider = { preferred = "fernflower" },
                    },
                },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
        end
    }
}

