return {
  -- 1. syntax highlighter: parser via Tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "mermaid" })
      end
    end,
  },

  -- 2. Mermaid - instant preview, lint, formatter
  {
    "kevalin/mermaid.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "mermaid" },
    config = function()
      local mermaid = require("mermaid")
      
      mermaid.setup({
        -- default is on, more to add here
        -- 1. sync colorscheme with dark/light mode
        -- 2. built in local HTTP server for smooth interaction
      })

      vim.keymap.set("n", "<leader>mp", "<cmd>Mermaid preview<cr>", { desc = "Instant Mermaid preview" })
      vim.keymap.set("n", "<leader>mf", "<cmd>Mermaid format<cr>", { desc = "Format current Mermaid code" })
    end,
  }
}
