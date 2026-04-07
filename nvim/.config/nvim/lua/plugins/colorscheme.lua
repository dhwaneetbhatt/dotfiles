return {
  -- Colorscheme with both light and dark variants
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto", -- uses latte (light) or mocha (dark) based on vim.o.background
      background = {
        light = "latte",
        dark = "mocha",
      },
    },
  },

  -- Auto-switch based on macOS system appearance
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1001,
    opts = {
      update_interval = 3000, -- check every 3 seconds
      set_dark_mode = function()
        vim.o.background = "dark"
      end,
      set_light_mode = function()
        vim.o.background = "light"
      end,
    },
  },

  -- Tell LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
