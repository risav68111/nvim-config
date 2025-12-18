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

function M.run()
  -- Detect Spring Boot
  local is_springboot =
    file_contains("pom.xml", "spring%-boot")
    or file_contains("build.gradle", "spring%-boot")

  if is_springboot then
    local mvnw_exists = file_exists("./mvnw")
    cmd = mvnw_exists
      and { "./mvnw", "spring-boot:run" }
      or { "mvn", "spring-boot:run" }
  else
    cmd = "mvn clean compile exec:java"
  end

  vim.cmd("wa")

  -- Open terminal in current window
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(0, buf)

  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end


return M
