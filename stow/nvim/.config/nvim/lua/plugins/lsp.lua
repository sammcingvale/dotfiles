-- Modern LSP setup using Neovim 0.11+ core API (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig is still installed because it ships server-specific
-- configs (cmd, filetypes, root_markers) that vim.lsp picks up automatically.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- Servers we want enabled. Names match nvim-lspconfig's lsp/*.lua files.
      local servers = {
        "lua_ls", "pyright", "ts_ls", "rust_analyzer",
        "clangd", "bashls", "jsonls", "yamlls", "marksman",
      }

      -- Install via mason
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", "ruff", "prettier", "shellcheck",
        },
      })

      -- Per-server overrides. nvim-lspconfig provides sensible defaults
      -- via its bundled lsp/*.lua files; we just layer extras on top.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- Enable every server. vim.lsp resolves each name against
      -- runtimepath/lsp/<name>.lua (provided by nvim-lspconfig).
      vim.lsp.enable(servers)

      -- Buffer-local keymaps when an LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition,         "Goto definition")
          map("gr", vim.lsp.buf.references,         "References")
          map("gi", vim.lsp.buf.implementation,     "Implementation")
          map("K",  vim.lsp.buf.hover,              "Hover")
          map("<leader>rn", vim.lsp.buf.rename,     "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,"Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })

      -- Diagnostic appearance
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
    end,
  },
}
