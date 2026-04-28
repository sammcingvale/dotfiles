return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",   desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",    desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",    desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",     desc = "Recent" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",      desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",     desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",  desc = "Diagnostics" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" },
    },
    opts = {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "smart" },
        layout_config = { horizontal = { preview_width = 0.55 } },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
