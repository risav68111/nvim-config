  

-- saves all files changing windows
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "wa", -- Write all changed buffers
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




vim.keymap.set("n", "<leader>r", function()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')            -- Get file name (e.g., "main.java")
  filepath = vim.fn.expand('%:p')                  -- Get full file path
  local filename= vim.fn.expand('%:t:r')   -- Get file name without extension

  if filetype == "java" then
    vim.cmd("!java " .. filename_no_ext)
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



-- Function to check if a package declaration already exists
local function hasPackage()
    for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 20, false)) do
        if line:match("%S") then -- Check if the line is not empty
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

-- Function to insert package declaration if not present
local function insertPackage()
    if hasPackage() then
        print("🚨 Package already exists in this file!")
        return
    end

    local filepath = vim.fn.expand("%:p:h") -- Get directory path
    local project_root = vim.fn.getcwd() -- Assuming Neovim is opened at project root

    -- Escape special characters for Windows paths
    local escaped_root = vim.fn.escape(project_root, "\\")

    -- Convert directory path into package name
    local relative_path = filepath:gsub("^" .. escaped_root .. "[\\/]*", ""):gsub("[\\/]", ".")
    local package_name = relative_path ~= "" and "package " .. relative_path .. ";" or ""

    -- Insert package declaration at the top
    if package_name ~= "" then
        vim.api.nvim_buf_set_lines(0, 0, 0, false, {package_name, ""})
        print("✅ Package inserted successfully!")
    end
end

-- Function to insert Java class if not present
local function insertClass()
    local filename = vim.fn.expand("%:t") -- Get file name
    local classname = filename:gsub("%.java$", "") -- Remove .java extension

    if hasClass(classname) then
        print("🚨 Class '" .. classname .. "' already exists in this file!")
        return
    end

    -- Java class template
    local template = {
        "public class " .. classname .. " {",
        "  public static void main(String[] args) {",
        "      System.out.println(\"Hello, " .. classname .. "!\");",
        "  }",
        "}"
    }

    -- Insert the class template
    vim.api.nvim_buf_set_lines(0, -1, -1, false, template)
    print("✅ Class inserted successfully!")
end

-- Function to insert both package & class safely
local function insert_full()
    insertPackage()
    insertClass()
end

-- Create Neovim commands
vim.api.nvim_create_user_command("Inspack", insertPackage, {})
vim.api.nvim_create_user_command("Insclass", insertClass, {})
vim.api.nvim_create_user_command("Insfull", insert_full, {})

