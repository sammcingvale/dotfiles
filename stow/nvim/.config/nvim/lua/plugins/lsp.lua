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
      -- Servers to install + use
      local servers = {
        lua_ls   = {
          settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        },
        pyright  = {},
        ts_ls    = {},     -- typescript/javascript
        rust_analyzer = {},
        clangd   = {},
        bashls   = {},
        jsonls   = {},
        yamlls   = {},
        marksman = {},     -- markdown
      }

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",        -- lua formatter
          "ruff",          -- python linter+formatter
          "prettier",
          "shellcheck",
        },
      })

      -- Default capabilities for autocompletion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp.default_capabilities(capabilities)
      end

      for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        require("lspconfig")[name].setup(cfg)
      end

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition,      "Goto definition")
          map("gr", vim.lsp.buf.references,      "References")
          map("gi", vim.lsp.buf.implementation,  "Implementation")
          map("K",  vim.lsp.buf.hover,           "Hover")
          map("<leader>rn", vim.lsp.buf.rename,  "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        end,
      })

      -- Diagnostic look
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
