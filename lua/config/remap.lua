vim.g.mapleader= " "

vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)


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


-- remove multiline comment
function RemoveMultiLineComment()
    local ft = vim.bo.filetype
    local comment_syntax = {
        c = { "/*", "*/" },
        cpp = { "/*", "*/" },
        java = { "/*", "*/" },
        javascript = { "/*", "*/" },
        lua = { "--[[", "]]" },
        python = { '"""', '"""' }
    }

    local comment = comment_syntax[ft]
    if not comment then
        print("Multi-line comment removal not supported for filetype: " .. ft)
        return
    end

    local block_start, block_end = comment[1], comment[2]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local cursor_line = vim.fn.line(".")
    
    local start_idx, end_idx = nil, nil

    -- Find the multi-line comment block
    for i, line in ipairs(lines) do
        if line:match(vim.pesc(block_start)) then
            start_idx = i
        end
        if line:match(vim.pesc(block_end)) then
            end_idx = i
        end
        if start_idx and end_idx then break end
    end

    -- If cursor is inside the comment block, remove it
    if start_idx and end_idx and cursor_line >= start_idx and cursor_line <= end_idx then
        for i = start_idx, end_idx do
            lines[i] = lines[i]:gsub(vim.pesc(block_start), "")
            lines[i] = lines[i]:gsub(vim.pesc(block_end), "")
        end
        vim.api.nvim_buf_set_lines(0, start_idx - 1, end_idx, false, lines)
    else
        print("Cursor is not inside a multi-line comment")
    end
end

vim.keymap.set("n", "<leader>uc", RemoveMultiLineComment, { noremap = true, silent = true })

