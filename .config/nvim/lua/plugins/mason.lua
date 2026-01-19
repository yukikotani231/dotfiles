-- Customize Mason

-- Helper: check if executable exists
local function has(cmd) return vim.fn.executable(cmd) == 1 end

-- Build ensure_installed list based on available tools
local ensure_installed = {
  -- Lua
  "lua-language-server",
  "stylua",

  -- TypeScript/JavaScript
  "typescript-language-server",
  "eslint-lsp",
  "prettierd",

  -- Python
  "pyright",
  "ruff",

  -- General
  "tree-sitter-cli",
}

-- Go tools (only if go is installed)
if has "go" then
  vim.list_extend(ensure_installed, {
    "gopls",
    "goimports",
    "gofumpt",
    "delve",
  })
end

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = ensure_installed,
    },
  },
}
