return {

  { "tpope/vim-sensible" },

  -- neo-tree.nvim LazyVim 默认。
  -- <leader>e

  -- toggleterm.nvim LazyVim 默认包含。
  -- <leader>ft

  -- 快速跳转 flash.nvim

  -- NERDTree (2008) Vimscript
  -- nvim-tree.lua (2020) Lua plugin
  -- neo-tree.nvim (2022) Lua + async + UI framework

  -- {
  --   "preservim/nerdtree",
  --   --cmd = "NERDTreeToggle",
  --   keys = {
  --     { "<leader>e", "<cmd>NERDTreeToggle<cr>" },
  --   },
  -- },

  --{ "github/copilot.vim" },

  -- <leader>ff
  -- 最近文件	<leader>fr
  -- 全局 grep	<leader>fg
  -- 搜索 buffer	<leader>fb
  -- 帮助	<leader>fh
  -- 查看 keymaps	<leader>?
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1,
  },
}
