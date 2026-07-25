return {
  --{ "ellisonleao/gruvbox.nvim" },
  -- LazyVim default is lualine
  -- { "vim-airline/vim-airline-themes" },
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}

-- "nvim-lualine/lualine.nvim",
-- dependencies = { "nvim-tree/nvim-web-devicons" }

