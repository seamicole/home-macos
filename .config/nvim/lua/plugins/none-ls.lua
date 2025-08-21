return {
  "nvimtools/none-ls.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    local augroup = vim.api.nvim_create_augroup("FormatOnSave", {})

    null_ls.setup({
      sources = {
        -- Prettier
        formatting.prettier.with({
          command = "npx",
          args = { "prettier", "--stdin-filepath", "$FILENAME" },
          filetypes = {
            "typescript","typescriptreact",
            "javascript","javascriptreact",
            "json","yaml","markdown","scss","css","html",
          },
        }),
        -- ESLint
        require("none-ls.diagnostics.eslint"),

        -- Dart formatter disabled (dartls handles Dart)
        -- formatting.dart_format,
      },

      -- Format on save for non-Dart only
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function(args)
              if vim.bo[args.buf].filetype == "dart" then return end
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}
