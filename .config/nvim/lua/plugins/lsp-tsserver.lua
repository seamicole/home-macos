return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    local lspconfig = require("lspconfig")

    -- Use tsserver (mapped to ts_ls under the hood)
    lspconfig.ts_ls.setup({
      on_attach = function(client, bufnr)
        -- Let none-ls handle formatting
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
  end,
}
