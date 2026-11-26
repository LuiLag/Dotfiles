-- ==========================================
-- 1. OPCIONES BÁSICAS Y PORTAPAPELES
-- ==========================================
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- ==========================================
-- 2. ATAJOS DE TECLADO ÚTILES
-- ==========================================
local keymap = vim.keymap.set
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Guardar archivo" })
keymap("i", "<C-s>", "<esc><cmd>w<cr>a", { desc = "Guardar archivo" })
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Limpiar búsqueda" })
keymap("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })
keymap("n", "<C-Left>", "<C-w>h", { desc = "Ir a ventana izquierda" })
keymap("n", "<C-Right>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- Atajos para ver errores de código (Diagnósticos LSP)
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Ver detalle del error" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Error anterior" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Siguiente error" })

-- ==========================================
-- 3. GESTOR DE PLUGINS (LAZY.NVIM)
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
-- 4. PLUGINS
-- ==========================================
require("lazy").setup({
  -- TEMA: Catppuccin Mocha transparente
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          neotree = true,
          treesitter = true,
          telescope = { enabled = true },
          cmp = true,
          which_key = true,
          mason = true,
          native_lsp = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- BARRA DE CARPETAS: Neo-tree a la izquierda
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Abrir/Cerrar carpetas" },
    },
    config = function()
      require("neo-tree").setup({
        window = { width = 30 },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
        },
      })
    end,
  },

  -- BARRA INFERIOR: Lualine
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

  -- RESALTADO DE SINTAXIS: Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      ts.install({
        "lua", "bash", "python", "c", "cpp", "javascript", "typescript",
        "html", "css", "json", "jsonc", "markdown", "vim", "vimdoc"
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- BUSCADOR RÁPIDO: Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto en proyecto" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Ver archivos abiertos" },
    },
  },

  -- CIERRE AUTOMÁTICO DE PARÉNTESIS Y COMILLAS
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- AUTOCOMPLETADO INTELIGENTE (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Conecta las sugerencias inteligentes del LSP
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- Prioridad a sugerencias reales del lenguaje
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- GESTOR DE SERVIDORES DE LENGUAJE: Mason y LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        -- Servidores que se instalarán automáticamente
        ensure_installed = {
          "lua_ls",   -- Lua (ideal para tu init.lua)
          "pyright",  -- Python
          "clangd",   -- C y C++
          "bashls",   -- Scripts Bash
          "html",     -- HTML
          "cssls",    -- CSS
          "ts_ls",    -- JavaScript y TypeScript
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          -- Evita que Lua marque "vim" como variable indefinida en tu init.lua
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                },
              },
            })
          end,
        },
      })

      -- Atajos inteligentes cuando abres un archivo con código
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          keymap("n", "gd", vim.lsp.buf.definition, opts)      -- Ir a definición
          keymap("n", "K", vim.lsp.buf.hover, opts)            -- Ver documentación
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- Renombrar variable
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Corrección rápida
        end,
      })
    end,
  },

  -- GUÍA DE ATAJOS EN PANTALLA (Which-key)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
})
