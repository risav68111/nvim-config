return {
  "mbbill/undotree",
  config = function()
    -- Disable the diff command to prevent errors
    vim.g.undotree_DiffAutoOpen = 0

    -- Keybinding: Press <leader> + u to toggle Undotree
    vim.keymap.set("n", "<leader><F5>", function()
      vim.cmd("UndotreeToggle")
    end, { noremap = true, silent = true })
  end
}
