-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ WEZTERM
-- └────────────────────────────────────────────────────────────────────────────────────

-- Ctrl + Option + T opens WezTerm in the current Finder folder
hs.hotkey.bind({ "ctrl", "alt" }, "t", function()
  -- Get current folder from Finder
  local ok, path = hs.osascript.applescript([[
    tell application "Finder"
      try
        set targetPath to (POSIX path of (target of front window as alias))
        return targetPath
      on error
        return ""
      end try
    end tell
  ]])

  -- Use home dir if Finder failed
  local dir = (path ~= "") and path or os.getenv("HOME")

  -- Launch WezTerm in that dir
  hs.execute(string.format('open -na "WezTerm" --args start --cwd %q', dir))
end)
