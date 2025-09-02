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

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ TELESCOPE
-- └────────────────────────────────────────────────────────────────────────────────────

-- Safely require telescope (avoids errors if not yet installed or disabled)
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  -- Safely require telescope builtins (core pickers: files, buffers, etc.)
  local ok_builtin, builtin = pcall(require, "telescope.builtin")

  -- Safely require live_grep_args extension (advanced ripgrep with args)
  local ok_lga, lga_ext = pcall(function()
    return require("telescope").extensions.live_grep_args
  end)

  -- ┌──────────────────────────────────────────────────────────────────────────────────
  -- │ TELESCOPE KEYBINDINGS
  -- └──────────────────────────────────────────────────────────────────────────────────

  -- Only define keymaps if builtin pickers are available
  if ok_builtin then
    -- Find files in project (respects .gitignore)
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })

    -- List open buffers
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

    -- Show recently opened files
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })

    -- Search Neovim help tags
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
  end

  -- Live grep (project-wide search)
  -- Prefer live_grep_args if available, else fallback to plain live_grep
  if ok_lga then
    vim.keymap.set("n", "<leader>fg", lga_ext.live_grep_args, { desc = "Live grep (args)" })
  elseif ok_builtin then
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  end
end
