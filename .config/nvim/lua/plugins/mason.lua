-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
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

        -- Rust (rust-analyzer is usually installed via rustup)
        -- "rust-analyzer",

        -- Go
        "gopls",
        "goimports",
        "gofumpt",
        "delve", -- debugger

        -- General
        "tree-sitter-cli",
      },
    },
  },
}
