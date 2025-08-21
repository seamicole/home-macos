return {
  "akinsho/flutter-tools.nvim",
  ft = { "dart" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- Define the augroup ONCE, outside on_attach
    local augroup = vim.api.nvim_create_augroup("DartFormatOnSave", {})

    require("flutter-tools").setup({
      lsp = {
        -- Format on save (dartls only)
        on_attach = function(_, bufnr)
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                async = false,
                timeout_ms = 2000,
                filter = function(c) return c.name == "dartls" end,
              })
            end,
          })
        end,
        flags = { debounce_text_changes = 150 },
      },
    })
  end,
}
