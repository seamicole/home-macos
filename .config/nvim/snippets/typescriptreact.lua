-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ VARIABLES
-- └────────────────────────────────────────────────────────────────────────────────────

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

-- ┌────────────────────────────────────────────────────────────────────────────────────
-- │ RETURN SNIPPET
-- └────────────────────────────────────────────────────────────────────────────────────

return {
  s(
    { trig = "!([^%c]+)", regTrig = true, wordTrig = false },
    f(function(_, snip)
      local heading = snip.captures[1]:gsub("^%s+", ""):gsub("%s+$", ""):upper()
      local width = 88
      local indent = vim.fn.indent(vim.fn.line("."))
      local line = "// ┌" .. string.rep("─", width - 4 - indent)
      local mid = "// │ " .. heading
      local bot = "// └" .. string.rep("─", width - 4 - indent)
      return { line, mid, bot, "" }
    end, {})
  ),
}
