-- ── Options ───────────────────────────────────────────────────────────
vim.g.mapleader     = " "
vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.number      = true
vim.opt.signcolumn  = "yes:1"
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.swapfile = false 
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim_undo"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.updatetime  = 250
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.o.autocomplete  = true

-- ── Keybinds -─────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "Open File Explorer" })

-- ── Plugins ───────────────────────────────────────────────────────────
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
  { src = 'https://github.com/mrcjkb/rustaceanvim' },
})

-- ── Colorscheme ───────────────────────────────────────────────────────
require("gruvbox").setup({
    terminal_colors = true,
    contrast = "soft",
    transparent_mode = true
})
vim.cmd.colorscheme("gruvbox")

-- ── Mason ─────────────────────────────────────────────────────────────
-- Installs LSP binaries. Run :MasonInstall after first launch:
--   rust-analyzer  typescript-language-server  eslint-lsp  prettierd
require("mason").setup()

-- ── LSP defaults ──────────────────────────────────────────────────────
vim.lsp.config("*", { root_markers = { ".git" } })
vim.lsp.enable({ "rust_analyzer", "ts_ls", "eslint" })

-- ── LSP attach ────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- Native completion
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
    end

    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    -- Keymaps
    local map = function(k, f) vim.keymap.set("n", k, f, { buffer = args.buf }) end
    map("gd",          vim.lsp.buf.definition)
    map("gD",          vim.lsp.buf.declaration)
    map("gr",          vim.lsp.buf.references)
    map("gi",          vim.lsp.buf.implementation)
    map("K",           vim.lsp.buf.hover)
    map("<leader>rn",  vim.lsp.buf.rename)
    map("<leader>ca",  vim.lsp.buf.code_action)
    map("[d",          vim.diagnostic.goto_prev)
    map("]d",          vim.diagnostic.goto_next)
    map("<leader>q",   vim.diagnostic.setloclist)
  end,
})

-- ── Treesitter ────────────────────────────────────────────────────────

-- ── Formatting ────────────────────────────────────────────────────────
require("conform").setup({
  formatters_by_ft = {
    rust       = { "rustfmt" },
    javascript = { "prettierd", stop_after_first = true },
    typescript = { "prettierd", stop_after_first = true },
    javascriptreact = { "prettierd", stop_after_first = true },
    typescriptreact = { "prettierd", stop_after_first = true },
  },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end)
