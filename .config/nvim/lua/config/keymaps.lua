-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- no gg / G on snacks
vim.keymap.set("n", "gg", "gg", { noremap = true, silent = true, desc = "Go to first line" })
--vim.keymap.set('n', 'G', 'G', { noremap = true, silent = true, desc = "Go to last line" })
