vim.g.mapleader= " "

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- vim.keymap.set("i", "<C-c>", <Esc>)

-- move selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<leader>p", "\"_dP")


-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)


-- multiline coment instead of single line comment 
function ToggleMultiLineComment()
  local filetype = vim.bo.filetype
  local comment_syntax = {
    ["c"] = { "/*", "*/" },
    ["cpp"] = { "/*", "*/" },
    ["java"] = { "/*", "*/" },
    ["javascript"] = { "/*", "*/" },
    ["python"] = { '"""', '"""' },
    ["lua"] = { "--[[", "--]]" },
    ["html"] = { "<!--", "-->" },
  }

  local comment = comment_syntax[filetype]
  if not comment then
    vim.notify("No multi-line comment syntax for " .. filetype, vim.log.levels.WARN)
    return
  end

  -- Get selected lines
  local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
  vim.fn.append(start_line - 1, comment[1]) -- Insert opening comment
  vim.fn.append(end_line + 1, comment[2])   -- Insert closing comment
end

-- Set a keymap to toggle comments in Visual Mode
vim.api.nvim_set_keymap('v', '<leader>mlc', ":lua ToggleMultiLineComment()<CR>", { noremap = true, silent = true })


