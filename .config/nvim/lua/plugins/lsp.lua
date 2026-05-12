return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    vim.lsp.config("ts_ls", {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      root_markers = {
        "tsconfig.json",
        "package.json",
        ".git",
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    vim.lsp.enable("ts_ls")

    vim.lsp.config("rust_analyzer", {
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    vim.lsp.enable("rust_analyzer")
  end,
}
