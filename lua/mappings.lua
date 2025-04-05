require("nvchad.mappings")
-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })
-- map("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
map(
  "n",
  "<Leader>fh",
  ':lua require"telescope.builtin".find_files({ hidden = true, no_ignore = true })<CR>',
  { noremap = true, silent = true }
)

-- Insert mode navigation (same as normal mode)
map("i", "<A-h>", "<Left>", { noremap = true, silent = true, desc = "Move left" })
map("i", "<A-l>", "<Right>", { noremap = true, silent = true, desc = "Move right" })
map("i", "<A-j>", "<Down>", { noremap = true, silent = true, desc = "Move down" })
map("i", "<A-k>", "<Up>", { noremap = true, silent = true, desc = "Move up" })

-- Half-page down and center cursor
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Half-page up and center cursor
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
-- Insert mode quick escape
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "jj", "<Esc>", { noremap = true, silent = true })

-- better up/down

map("n", "<C-w><Up>", ":resize +4<CR>", { noremap = true, silent = true })
map("n", "<C-w><Down>", ":resize -4<CR>", { noremap = true, silent = true })
map("n", "<C-w><Left>", ":vertical resize -4>", { noremap = true, silent = true })
map("n", "<C-w><Right>", ":vertical resize +4<CR>", { noremap = true, silent = true })
