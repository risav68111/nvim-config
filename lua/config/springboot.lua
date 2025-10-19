local M = {}

-- Helper: check if file exists
local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- Helper: check if a file contains a string
local function file_contains(path, pattern)
  if not file_exists(path) then return false end
  local lines = vim.fn.readfile(path)
  for _, line in ipairs(lines) do
    if line:match(pattern) then
      return true
    end
  end
  return false
end

-- Helper: determine if it's a Spring Boot project
local function is_springboot_project()
  return file_contains("pom.xml", "spring%-boot") or file_contains("build.gradle", "spring%-boot")
end

function M.run_springboot()
  if not is_springboot_project() then
    vim.notify("Not a Spring Boot project.", vim.log.levels.WARN)
    return
  end

  -- Determine whether to use mvnw or mvn
  local mvnw_exists = file_exists("./mvnw")
  local cmd = mvnw_exists and { "./mvnw", "spring-boot:run" } or { "mvn", "spring-boot:run" }

  -- Create a new tab and terminal buffer
  vim.cmd("wa")
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(0, buf)

  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end

return M
