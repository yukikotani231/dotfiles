-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

-- Helper: check if executable exists
local function has(cmd) return vim.fn.executable(cmd) == 1 end

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Lua
  { import = "astrocommunity.pack.lua" },

  -- TypeScript/JavaScript
  { import = "astrocommunity.pack.typescript" },

  -- Python (only if python3 is installed)
  { import = "astrocommunity.pack.python", cond = has "python3" },

  -- Rust (only if cargo is installed)
  { import = "astrocommunity.pack.rust", cond = has "cargo" },

  -- Go (only if go is installed)
  { import = "astrocommunity.pack.go", cond = has "go" },
}
