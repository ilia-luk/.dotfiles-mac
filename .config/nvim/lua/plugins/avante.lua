return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false,
    opts = {
      -- Default configuration
      hints = { enabled = false },

      ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "openai", -- Recommend using Claude
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5", -- your desired model (or use gpt-4o, etc.)
          api_key_name = "OPENAI_API_KEY",
          extra_request_body = {
            temperature = 1,
            max_completion_tokens = 120000, -- Increase this to include reasoning tokens (for reasoning models)
            --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          },
        },
      },

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "fzf", -- Avoid native provider issues
        provider_opts = {},
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      { "nvim-mini/mini.pick", optional = true }, -- for file_selector provider mini.pick
      { "nvim-telescope/telescope.nvim", optional = true }, -- for file_selector provider telescope
      { "hrsh7th/nvim-cmp", optional = true }, -- autocompletion for avante commands and mentions
      { "ibhagwan/fzf-lua", optional = true }, -- for file_selector provider fzf
      { "stevearc/dressing.nvim", optional = true }, -- for input provider dressing
      { "folke/snacks.nvim", optional = true }, -- for input provider snacks
      { "nvim-tree/nvim-web-devicons", optional = true }, -- or echasnovski/mini.icons
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        optional = true,
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      {
        "saghen/blink.cmp",
        optional = true,
        dependencies = {
          "Kaiser-Yang/blink-cmp-avante",
        },
        opts = {
          sources = {
            default = { "avante" },
            providers = { avante = { module = "blink-cmp-avante", name = "Avante" } },
          },
        },
      },
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          spec = {
            { "<leader>a", group = "ai" },
          },
        },
      },
    },
  },
}
