vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.wo.number = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.g.codeium_disable_bindings = 1
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")
local lazy
-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require("options")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "go", "python", "javascript", "typescript", "rust" }, -- Add languages
        highlight = { enable = true },
        incremental_selection = { enable = true },
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          enabled = true,
          jump_labels = true,
          keys = { "f", "F", "t", "T" }, -- Enables Flash for f/F/t/T
          search = { mode = "search" }, -- Multi-character search mode
          center = true,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
          vim.cmd("normal! zz")
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
          vim.cmd("normal! zz")
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
          vim.cmd("normal! zz")
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
          vim.cmd("normal! zz")
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
          vim.cmd("normal! zz")
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  -- Lazy.nvim plugin configuration for Codeium
  {
    "Exafunction/codeium.vim",
    config = function()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-;>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")
vim.schedule(function()
  require("mappings")
end)

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = #picker:get_multi_selection()

  if num_selections > 1 then
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", ":e!", entry.value))
    end
    vim.cmd("stopinsert")
  else
    actions.file_edit(prompt_bufnr)
  end
end

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<cr>"] = custom_actions.fzf_multi_select,
      },
      n = {
        ["<esc>"] = actions.close,
        ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<cr>"] = custom_actions.fzf_multi_select,
      },
    },
  },
})

local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    -- Auto format and organize imports on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true }) -- Fix imports
        vim.lsp.buf.format() -- Format code
      end,
    })
  end,
})
