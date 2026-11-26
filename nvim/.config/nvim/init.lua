-- ==========================================
-- 1. OPCIONES BÁSICAS Y PORTAPAPELES
-- ==========================================
vim.g.mapleader = " "              -- Tecla líder = Barra espaciadora
vim.opt.number = true              -- Mostrar números de línea
vim.opt.relativenumber = true      -- Números relativos para moverte rápido
vim.opt.tabstop = 4                -- Tamaño de tabulación = 4 espacios
vim.opt.shiftwidth = 4
vim.opt.expandtab = true           -- Convertir tabs en espacios
vim.opt.termguicolors = true       -- Colores reales de 24-bit (necesario para Catppuccin)
vim.opt.clipboard = "unnamedplus"  -- Conectar con portapapeles de Hyprland (wl-clipboard)
vim.opt.cursorline = true          -- Resaltar la línea actual

-- ==========================================
-- 2. INSTALACIÓN AUTOMÁTICA DE LAZY.NVIM
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. PLUGINS ESTÉTICOS Y FUNCIONALES
-- ==========================================
require("lazy").setup({
  -- Tema Catppuccin Mocha con transparencia
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Barra vertical de carpetas a la izquierda (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- Iconos de archivos
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Abrir/Cerrar árbol de carpetas" },
    },
  },

  -- Barra de estado inferior estética (Lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },
})

