-- stylua: ignore
--
-- :Lazy profile
--
-- :echo string(mapleader)
-- :echo char2nr(mapleader)
-- :lua print(vim.inspect(vim.g.mapleader))
-- LazyVim 默认配置是：
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"
-- :WhichKey g

--init.lua
--   │
--   ▼
--config.lazy
--   │
--   ▼
--扫描 lua/plugins/*.lua
--   │
--   ├─ core.lua
--   ├─ extras.lua
--   ├─ ui.lua
--   ├─ coding.lua
--   ├─ markdown.lua
--   └─ tools.lua

-- 当插件拆成多个文件后 order check 已经没有意义。
-- Lazy.nvim 会 自动 merge 所有 plugin spec。
vim.g.lazyvim_check_order = false

-- 如何让 Copilot + nvim-cmp 自动补全
-- 如何让 LazyVim 变成 JetBrains 级 IDE

return {
  --主题需要最早加载
  --否则 UI 会闪烁
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
