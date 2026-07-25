return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 确保在其他插件之前加载
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- 可选: latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- 如果需要透明背景，设为 true
        show_end_of_buffer = false,
        integration = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          -- 更多集成请查看官方文档
        },
      })

      -- 加载主题
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
