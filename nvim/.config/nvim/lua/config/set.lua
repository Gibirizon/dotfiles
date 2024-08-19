local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "

-------------------------------------- options ------------------------------------------
-- o.laststatus = 3
-- o.showmode = false

o.clipboard = "unnamedplus"
-- o.cursorline = true
-- o.cursorlineopt = "number"

-- opt.fillchars = { eob = " " }
-- o.ignorecase = true
-- o.smartcase = true
-- o.mouse = "a"
--
-- -- Numbers
-- o.number = true
-- o.numberwidth = 2
-- o.ruler = false
--
-- o.splitbelow = true
-- o.splitright = true
-- o.timeoutlen = 400
--
-- g.loaded_node_provider = 0
-- g.loaded_python3_provider = 0
-- g.loaded_perl_provider = 0
-- g.loaded_ruby_provider = 0
--
-- -- add binaries installed by mason.nvim to path
-- local is_windows = vim.fn.has "win32" ~= 0
-- local sep = is_windows and "\\" or "/"
-- local delim = is_windows and ";" or ":"
-- vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

opt.nu = true
opt.relativenumber = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true
opt.smarttab = true
opt.autoindent = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv "HOME" .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append "@-@"

opt.updatetime = 50

vim.g.mapleader = " "

opt.colorcolumn = "100"
