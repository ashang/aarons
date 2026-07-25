return {

  -- LazyVim 原生 LSP 彻底替换 coc.nvim
  -- native LSP + nvim-cmp + mason.nvim
  -- coc.nvim = node.js runtime
  -- 启动时： spawn node process
  -- 最大性能杀手
  -- { "neoclide/coc.nvim", branch = "release", build = ":CocInstall" },

  -- 核心插件： telescope.nvim ripgrep LazyVim 默认已经安装。
  -- <leader>ff   file search
  -- <leader>fg   grep project
  -- <leader>fb   buffers

  -- <leader>fg  -> 搜索整个仓库

  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- 快捷键： <leader>gg
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },

  -- 快捷键： <leader>a
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
  },

  -- easy align
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    },
  },

  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Treesitter (确保支持 Markdown 且不覆盖默认配置)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "tsx",
          "typescript",
          "vim",
        })
      end
    end,
  },
}
