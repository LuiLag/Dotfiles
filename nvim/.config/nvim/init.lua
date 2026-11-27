-- ============================================================================
-- 1. OPCIONES BÁSICAS Y PORTAPAPELES DEL SISTEMA
-- Descripción: Números relativos, sangría de 4 espacios, búsqueda inteligente
-- y sincronización directa con el portapapeles de Wayland.
-- ============================================================================
vim.g.mapleader = " "              -- Tecla líder principal: Barra Espaciadora
vim.opt.number = true              -- Muestra el número de la línea actual
vim.opt.relativenumber = true      -- Distancia relativa en líneas (útil para 5j / 10k)
vim.opt.tabstop = 4                -- Ancho visual de tabulación: 4 espacios
vim.opt.shiftwidth = 4             -- Ancho al indentar bloques: 4 espacios
vim.opt.expandtab = true           -- Convierte tabulaciones en espacios reales
vim.opt.smartindent = true         -- Indenta automáticamente al abrir bloques
vim.opt.wrap = false               -- Evita que líneas largas se partan visualmente
vim.opt.ignorecase = true          -- Ignora mayúsculas al buscar...
vim.opt.smartcase = true           -- ...excepto si escribes una mayúscula
vim.opt.termguicolors = true       -- Colores reales de 24 bits en Kitty
vim.opt.clipboard = "unnamedplus"  -- Conecta 'y' y 'p' directo con wl-clipboard
vim.opt.cursorline = true          -- Resalta suavemente la línea actual
vim.opt.signcolumn = "yes"         -- Mantiene fija la columna izquierda de iconos

-- ============================================================================
-- 2. ATAJOS DE TECLADO ESENCIALES (KEYMAPS)
-- ============================================================================
local keymap = vim.keymap.set
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Guardar archivo" })
keymap("i", "<C-s>", "<esc><cmd>w<cr>a", { desc = "Guardar archivo" })
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Limpiar búsqueda" })
keymap("n", "<C-h>", "<C-w>h", { desc = "Ir a panel izquierdo" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Ir a panel derecho" })
keymap("n", "<C-Left>", "<C-w>h", { desc = "Ir a panel izquierdo" })
keymap("n", "<C-Right>", "<C-w>l", { desc = "Ir a panel derecho" })

-- Diagnósticos de código (Errores LSP)
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Ver detalle del error" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Error anterior" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Siguiente error" })

-- ============================================================================
-- 3. GESTOR DE PLUGINS (LAZY.NVIM)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- 4. PLUGINS Y ENTORNOS DE DESARROLLO
-- ============================================================================
require("lazy").setup({

  -- 4.1 TEMA VISUAL: Catppuccin Mocha transparente
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          neotree = true, treesitter = true, telescope = { enabled = true },
          cmp = true, which_key = true, mason = true,
          native_lsp = { enabled = true }, indent_blankline = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- 4.2 GUÍAS VISUALES DE INDENTACIÓN (Líneas verticales en cada bloque)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- 4.3 ÁRBOL DE CARPETAS: Neo-tree (Espacio + e)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Abrir/Cerrar carpetas" } },
    config = function()
      require("neo-tree").setup({
        window = { width = 30 },
        filesystem = { filtered_items = { visible = true, hide_dotfiles = false } },
      })
    end,
  },

  -- 4.4 BARRA INFERIOR: Lualine
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

  -- 4.5 RESALTADO DE SINTAXIS: Treesitter
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
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },

  -- 4.6 BUSCADOR RÁPIDO: Telescope (Espacio + ff / fg)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Archivos abiertos" },
    },
  },

  -- 4.7 CIERRE AUTOMÁTICO DE PARÉNTESIS Y COMILLAS: Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- 4.8 AUTOCOMPLETADO INTELIGENTE: nvim-cmp + LuaSnip + Autopairs
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" },
        }),
      })
    end,
  },

  -- 4.9 SERVIDORES DE LENGUAJE (LSP) Y MASON
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason").setup({
        ui = { border = "rounded", icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
      })
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "clangd", "bashls", "html", "cssls", "ts_ls" },
        handlers = {
          function(server_name) require("lspconfig")[server_name].setup({ capabilities = capabilities }) end,
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = { Lua = { diagnostics = { globals = { "vim" } } } },
            })
          end,
        },
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },

  -- 4.10 GUÍA VISUAL DE ATAJOS: Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },
})
