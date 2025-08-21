-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ UI SETTINGS
-- └────────────────────────────────────────────────────────────────────────────────────

-- Configure absolute line numbers
vim.opt.number = true

-- Configure relative line numbers
vim.opt.relativenumber = false

-- Configure cursor line
vim.opt.cursorline = true

-- Configure line wrapping
vim.opt.wrap = false

-- Display vertical line stops
vim.opt.colorcolumn = "88,100"

-- Configure clipboard settings
vim.opt.clipboard = "unnamedplus"

-- Configure true color support
vim.opt.termguicolors = true

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ INDENTATION
-- └────────────────────────────────────────────────────────────────────────────────────

-- Configure tabstops and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Configure tabstops and indentation for JavaScript and TypeScript
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "html",
    "css", "scss", "less",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "dart",
  },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ PERSISTENT UNDOS
-- └────────────────────────────────────────────────────────────────────────────────────

-- Enable undos that persist accross sessions
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.local/share/nvim/undo")

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ AUTOCMD: TRIM TRAILING LINES ON WRITE
-- └────────────────────────────────────────────────────────────────────────────────────

-- Trim trailing lines
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local last_line = vim.fn.line("$")
    while last_line > 1 and vim.fn.getline(last_line):match("^%s*$") do
      vim.api.nvim_buf_set_lines(0, last_line - 1, last_line, false, {})
      last_line = last_line - 1
    end
  end,
})

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ AUTOCMD: DISABLE AUTO COMMENT FORMATTING ON NEW LINES
-- └────────────────────────────────────────────────────────────────────────────────────

-- Disable auto comment formatting on new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ KEY MAPPINGS
-- └────────────────────────────────────────────────────────────────────────────────────

-- Search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Diagnostics navigation + float
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ LAZY PLUGIN MANAGER
-- └────────────────────────────────────────────────────────────────────────────────────

-- Initialize lazy.nvim
vim.opt.rtp:prepend("~/.config/nvim/lazy/lazy.nvim")

-- Setup plugins
require("lazy").setup("plugins")
