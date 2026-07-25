return {

  {
    "dhruvasagar/vim-table-mode",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.table_mode_corner = "|"

      --vim.keymap.set("n", "<leader>tm", ":TableModeToggle<CR>", { desc = "Toggle Table Mode" })
      vim.keymap.set("n", "<leader>tm", ":TableModeToggle<CR>", { desc = "Toggle Table Mode" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.schedule(function()
            vim.cmd("TableModeEnable")
          end)
        end,
      })
    end,
  },
}
