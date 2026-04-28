return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "cmake", "dockerfile",
        "json", "lua", "make", "markdown", "markdown_inline",
        "python", "rust", "toml", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
        "arduino", -- for the rocket project
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          node_decremental  = "<bs>",
          scope_incremental = false,
        },
      },
    },
  },
}
