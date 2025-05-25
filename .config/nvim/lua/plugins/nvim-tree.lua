return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for icons
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
      },
      filters = {
        dotfiles = false,
      },
    })
    -- Key Mappings
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    vim.keymap.set("n", "<leader>w", "<C-w>w", { desc = "Switch window" })
  end,
}
