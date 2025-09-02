-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ TELESCOPE
-- └────────────────────────────────────────────────────────────────────────────────────

return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")

    -- Detect available CLIs
    local has = function(bin) return vim.fn.executable(bin) == 1 end
    local has_fd, has_fdfind, has_rg = has("fd"), has("fdfind"), has("rg")

    -- Choose a find command that actually exists.
    -- Order: fd > fdfind > rg --files > find
    local function pick_find_command()
      if has_fd then
        return { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
      elseif has_fdfind then
        return { "fdfind", "--type", "f", "--hidden", "--follow", "--exclude", ".git" }
      elseif has_rg then
        return { "rg", "--files", "--hidden", "--glob", "!.git/*" }
      else
        -- Portable fallback (BSD/macOS + GNU): list files, skip .git
        return { "find", ".", "-type", "f", "-not", "-path", "*/.git/*" }
      end
    end

    -- Prefer searching from Git root if in a repo; else use current cwd.
    local function project_cwd()
      local ok, out = pcall(vim.fn.systemlist, { "git", "rev-parse", "--show-toplevel" })
      if ok and out and #out > 0 and vim.v.shell_error == 0 then
        return out[1]
      end
      return vim.loop.cwd()
    end

    -- Build vimgrep_arguments only if ripgrep exists
    local vimgrep_args = nil
    if has_rg then
      vimgrep_args = {
        "rg",
        "--hidden",
        "--follow",
        "--glob", "!.git/*",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      }
    end

    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/" },
        mappings = {
          i = { ["<C-h>"] = "which_key" },
        },
        vimgrep_arguments = vimgrep_args, -- nil is fine; live_grep just won’t work without rg
      },

      pickers = {
        -- Always supply a working command and search from project root
        find_files = {
          cwd = project_cwd(),
          find_command = pick_find_command(),
        },
        live_grep = {
          cwd = project_cwd(),
        },
      },

      extensions = {
        fzf = { case_mode = "smart_case" },
      },
    })

    -- Load extensions if present
    telescope.load_extension("fzf")
    pcall(telescope.load_extension, "live_grep_args")

    -- Optional: show a one-time heads-up if ripgrep is missing (so live_grep_args won’t work)
    if not has_rg then
      vim.schedule(function()
        vim.notify(
          "[telescope] ripgrep (rg) not found; live_grep is disabled. Install rg for project-wide search.",
          vim.log.levels.WARN
        )
      end)
    end
  end,
}
