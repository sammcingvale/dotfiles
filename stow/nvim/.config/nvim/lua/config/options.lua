-- Core editor options.
local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.termguicolors  = true
opt.showmode       = false        -- statusline shows it
opt.laststatus     = 3            -- global statusline
opt.cmdheight      = 1
opt.pumheight      = 10
opt.splitright     = true
opt.splitbelow     = true
opt.wrap           = false

-- Indent
opt.expandtab   = true
opt.shiftwidth  = 2
opt.tabstop     = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

-- Files / undo
opt.swapfile     = false
opt.backup       = false
opt.undofile     = true
opt.undodir      = vim.fn.stdpath("data") .. "/undo"
opt.updatetime   = 250
opt.timeoutlen   = 400

-- Clipboard — use system
opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"

-- Better completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Folding via treesitter
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldlevel      = 99
opt.foldlevelstart = 99

-- Avoid showing column at end of line
opt.colorcolumn = "100"
