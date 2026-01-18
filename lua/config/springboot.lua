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

  local has_pom        = file_exists("pom.xml")
  local has_gradle    = file_exists("build.gradle") or file_exists("build.gradle.kts")
  local has_mvnw      = file_exists("mvnw")
  local has_gradlew   = file_exists("gradlew")

  local is_springboot =
    file_contains("pom.xml", "spring%-boot")
    or file_contains("build.gradle", "spring%-boot")
    or file_contains("build.gradle.kts", "spring%-boot")

  local cmd

  if is_springboot then
    if has_gradle then
      cmd = has_gradlew
        and { "./gradlew", "bootRun" }
        or { "gradle", "bootRun" }
    else
      if not has_pom then
        return
      end
      cmd = has_mvnw
        and { "./mvnw", "spring-boot:run" }
        or { "mvn", "spring-boot:run" }
    end
  else
    if has_gradle then
      cmd = has_gradlew
        and { "./gradlew", "run" }
        or { "gradle", "run" }
    else
      if not has_pom then
        return
      end
      cmd = has_mvnw
        and { "./mvnw", "clean", "compile", "exec:java" }
        or { "mvn", "clean", "compile", "exec:java" }
    end
  end

  vim.cmd("wa")
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(0, buf)

  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end


return M
