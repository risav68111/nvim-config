return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-web-devicons").setup({}) -- Ensure devicons are set up
        require("nvim-tree").setup({
            renderer = {
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
        })

        -- Keybinding to toggle Nvim Tree
        vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = false, silent = true })
    end,
}

