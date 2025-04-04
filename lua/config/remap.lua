vim.g.mapleader= " "

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

vim.keymap.set("i", "<C-c>", "<Esc>")

-- move selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<leader>p", "\"_dp")


-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Jump between markdown headers
vim.keymap.set("n", "<leader>j", [[/^##\+<CR>]], { buffer = true, silent = true })
vim.keymap.set("n", "<leader>k", [[?^##\+<CR>]], { buffer = true, silent = true })

-- Replace word under cursor 
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/>]], { desc = "Replace word under cursor" })


-- Search for highlighted text in buffer
vim.keymap.set("v", "//", 'y/<C-R>"', { desc = "Search for highlighted text" })

-- highlight searched text in buffer file
vim.keymap.set("n", "<leader>hls", function()
  vim.o.hlsearch = not vim.o.hlsearch
  print("Highlight Search: " .. (vim.o.hlsearch and "ON" or "OFF"))
end, { desc = "Toggle highlight search" })


vim.keymap.set("n", "<leader>nn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>b", vim.cmd.bprev)
