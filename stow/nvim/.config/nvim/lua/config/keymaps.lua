-- Keybindings. Plugin-specific maps live in plugin specs; this file
-- holds editor-level bindings.

local map = vim.keymap.set

-- Faster save / quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Clear search highlight
map("n", "<esc>", "<cmd>nohlsearch<cr>", { silent = true })

-- Better window nav
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize splits
map("n", "<C-Up>",    "<cmd>resize +2<cr>")
map("n", "<C-Down>",  "<cmd>resize -2<cr>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Move lines (alt+j / alt+k)
map("n", "<A-j>", "<cmd>m .+1<cr>==",         { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",         { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",         { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",         { desc = "Move selection up" })

-- Stay centered when scrolling / searching
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Keep visual block after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Yank to end of line consistent with D, C
map("n", "Y", "y$")

-- Don't replace register on paste over selection
map("x", "p", '"_dP')

-- Buffer navigation
map("n", "<S-h>",      "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>",   { desc = "Delete buffer" })

-- Quickfix
map("n", "<leader>xo", "<cmd>copen<cr>",  { desc = "Open quickfix" })
map("n", "<leader>xc", "<cmd>cclose<cr>", { desc = "Close quickfix" })
map("n", "]q",         "<cmd>cnext<cr>",  { desc = "Next quickfix" })
map("n", "[q",         "<cmd>cprev<cr>",  { desc = "Prev quickfix" })

-- Diagnostics
map("n", "]d", function() vim.diagnostic.jump({ count = 1 })  end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Toggle relative numbers
map("n", "<leader>tr", function() vim.wo.relativenumber = not vim.wo.relativenumber end,
  { desc = "Toggle relative #" })
