-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Lua
  { import = "astrocommunity.pack.lua" },

  -- TypeScript/JavaScript
  { import = "astrocommunity.pack.typescript" },

  -- Python
  { import = "astrocommunity.pack.python" },

  -- Rust
  { import = "astrocommunity.pack.rust" },

  -- Go
  { import = "astrocommunity.pack.go" },
}
