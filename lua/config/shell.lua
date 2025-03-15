

vim.keymap.set("n", "<leader>r", function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:t')        -- Get file name (e.g., "main.java")
  filepath = vim.fn.expand('%:p')        -- Get full file path
    local filename_no_ext = vim.fn.expand('%:t:r') -- Get file name without extension

    if filetype == "java" then
        vim.cmd("!javac " .. filename .. " && java " .. filename_no_ext)
    elseif filetype == "lua" then
        vim.cmd("!lua " .. filepath)
    elseif filetype == "python" then
        vim.cmd("!python " .. filepath)
    elseif filetype == "c" then
        vim.cmd("!gcc " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext)
    elseif filetype == "cpp" then
        vim.cmd("!g++ " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext)
    else
        print("Unsupported file type: " .. filetype)
    end
end, { noremap = true, silent = true })

