vim.g.mapleader = " "

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("i", "<leader>jf", "<Esc>")
-- vim.keymap.set("i", "<leader>fj", "<Esc>")
-- vim.keymap.set("i", "jjff", "<Esc>")
-- vim.keymap.set("i", "fjf", "<Esc>")

-- move selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<leader>p", "\"_dp")


-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Jump between markdown headers
vim.keymap.set("n", "<leader>j", [[/^##\+<CR>]], { buffer = true, silent = true })
vim.keymap.set("n", "<leader>k", [[?^##\+<CR>]], { buffer = true, silent = true })

-- Replace word under cursor
vim.keymap.set("n", "<leader>re", [[:%s/]], { desc = "open replace " })
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/]], { desc = "Replace word under cursor" })


-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"', { desc = "Search for highlighted text" })

-- highlight searched text in buffer file
vim.keymap.set("n", "<leader>hls", function()
  vim.o.hlsearch = not vim.o.hlsearch
  print("Highlight Search: " .. (vim.o.hlsearch and "ON" or "OFF"))
end, { desc = "Toggle highlight search" })


vim.keymap.set("n", "<leader>nn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>b", vim.cmd.bprev)

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Docs" })

vim.keymap.set("n", "<A-L>", ":vertical resize +5<CR>")
vim.keymap.set("n", "<A-H>", ":vertical resize -5<CR>")
vim.keymap.set("n", "<A-K>", ":resize +2<CR>")
vim.keymap.set("n", "<A-J>", ":resize -2<CR>")

vim.g.netrw_browse_split = 0
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "f", "<Plug>NetrwLocalBrowseCheck", { buffer = true })
  end,
})

local springboot= require('config.springboot')

vim.keymap.set("n", "<F10>", springboot.run_springboot, { desc = "Run Spring Boot App" })
