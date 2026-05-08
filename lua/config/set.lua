vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.opt.ignorecase = true
vim.opt.smartcase = true


-- vim.opt.list= true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.lsp.config('*',
    { handlers = { ['textDocument/hover'] = function(err, result, ctx, config)
        config = vim.tbl_deep_extend("force", config or {},
            { border = border, padding = { top = 1, bottom = 1, left = 2, right = 2 }, })
        vim.lsp.handlers.hover(err, result, ctx, config)
    end, } })
