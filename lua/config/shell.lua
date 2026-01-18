vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  callback = function()
    pcall(vim.cmd, "silent! update")
  end
})

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

vim.api.nvim_create_user_command("Run", function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  local filepath = vim.fn.expand('%:p')
  local filename_no_ext = vim.fn.expand('%:t:r')
  local command

  if filetype == "java" then
    command = "java " .. filename
  elseif filetype == "lua" then
    command = "lua " .. filepath
  elseif filetype == "python" then
    command = "python " .. filepath
  elseif filetype == "c" then
    -- Compile and run C code
    command = "gcc " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
  elseif filetype == "cpp" then
    -- Compile and run C++ code
    command = "g++ " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
  elseif filetype == "go" then
    command = "go run " .. filename
  else
    vim.notify("Unsupported file type: " .. filetype)
    return
  end

  -- Use vim.cmd("terminal ...") to run the command in a new terminal buffer
  vim.cmd("vsplit | terminal " .. command) end, {})

-- Function to check if a package declaration already exists
local function hasPackage()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 20, false)) do
    if line:match("%S") then                  -- Check if the line is not empty
      return line:match("^package%s+") ~= nil -- Return true if it starts with 'package'
    end
  end
  return false
end

-- Function to check if a class declaration already exists
local function hasClass(classname)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match("^public%s+class%s+" .. classname) then
      return true
    end
  end
  return false
end

local function file_exists(path, filenames)
  for _, filename in ipairs(filenames) do
    if vim.fn.filereadable(path .. "/" .. filename) == 1 then
      return true
    end
  end
  return false
end

-- Function to insert package declaration if not present
local function insertPackage()
  if vim.bo.filetype ~= 'java' then
    vim.notify("File is not java")
    return
  end

  local filepath = vim.fn.expand("%:p:h") -- Absolute directory of current file

  local project_root = vim.fn.getcwd()    -- Project root (assumes opened from project root)

  -- Ensure project root ends with a slash
  if not project_root:match("/$") then
    project_root = project_root .. "/"
  end

  -- vim.notify("root dir: " .. project_root)
  if not file_exists(project_root, { "pom.xml", "build.gradle" }) then
    vim.notify("Unable to identify java project root dir")
    return
  end

  if hasPackage() then
    vim.notify("Package already exists in this file!")
    return
  end

  -- Normalize paths to forward slashes
  filepath = filepath:gsub("\\", "/")
  project_root = project_root:gsub("\\", "/")

  -- Get relative path from project root
  local relative_path = filepath:gsub("^" .. vim.pesc(project_root), "")

  local package_name = relative_path:match("/java/(.*)")

  if package_name == nil then
    vim.notify("unable to find package")
    return
  end

  package_name = package_name:gsub("/", ".")

  -- Insert package declaration
  if package_name ~= "" then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "package " .. package_name .. ";", "" })
    vim.notify("Package inserted: package " .. package_name)
  else
    vim.notify("Could not determine package name")
  end
end

-- Function to insert Java class if not present
local function insertClass()
  local filename = vim.fn.expand("%:t")          -- Get file name
  local classname = filename:gsub("%.java$", "") -- Remove .java extension

  if vim.bo.filetype ~= 'java' then
    vim.notify("File is not java")
    return
  end

  if hasClass(classname) then
    vim.notify("Class '" .. classname .. "' already exists in this file!")
    return
  end

  -- Java class template
  local template = {
    "public class " .. classname .. " {",
    "  ",
    "}"
  }

  -- Insert the class template
  vim.api.nvim_buf_set_lines(0, -1, -1, false, template)
  vim.notify("Class inserted successfully!")
end

-- Function to insert both package & class safely
local function insert_full()
  insertPackage()
  insertClass()
end

-- Create Neovim commands
vim.api.nvim_create_user_command("Insp", insertPackage, {})
vim.api.nvim_create_user_command("Insc", insertClass, {})
vim.api.nvim_create_user_command("Ins", insert_full, {})


local function insertReact()
  local filename = vim.fn.expand("%:t")           -- Get file name
  local filename_na = filename:gsub("%.jsx$", "") -- Remove .java extension

  -- Java class template
  local template = {
    "import React, { useEffect, useState } from \'react\'",
    "import axios from 'axios'",
    " ",
    "const " .. filename_na .. " = () => {",
    " ",
    "}",
    " ",
    "default export " .. filename_na .. "",
  }

  -- Insert the class template
  vim.api.nvim_buf_set_lines(0, -1, -1, false, template)
  vim.notify("RAFC inserted successfully!")
end

vim.api.nvim_create_user_command("Rafc", insertReact, {})

vim.api.nvim_create_user_command("Gorun", function()
  local cmd

  -- Detect Go module
  local has_go_mod = vim.fn.filereadable("go.mod") == 1

  if has_go_mod then
    cmd = { "go", "run", "." }
  else
    local file = vim.fn.expand("%")
    if file == "" then
      vim.notify("No Go file to run", vim.log.levels.ERROR)
      return
    end
    cmd = { "go", "run", file }
  end

  -- Save all files
  vim.cmd("wa")

  -- Vertical split
  vim.cmd("split")

  -- Create terminal buffer in the new split
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(0, buf)

  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end, {})
