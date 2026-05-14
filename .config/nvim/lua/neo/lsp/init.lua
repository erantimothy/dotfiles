-- neo/lsp/init.lua
-- local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local map = vim.keymap.set

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "<leader>lr", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
end

-- adding snippets and autocompletion docs for per server config globally to merge below
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Setup Mason and handlers
mason_lspconfig.setup({
  ensure_installed = {
      "lua_ls",
      "clangd",
      "eslint",
      "pyright",
      "stylua",
  },
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    -- Try to load custom server-specific config and merge with global configs
    local has_custom, custom_opts = pcall(require, "neo.lsp.servers." .. server_name)
    if has_custom then
      opts = vim.tbl_deep_extend("force", opts, custom_opts)
    end

    -- local lspconfig = require("lspconfig")
    -- lspconfig[server_name].setup(opts)
    vim.lsp.config[server_name].setup(opts)
    vim.lsp.enable(server_name)
  end,
})

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
}) 

local signs = { Error = "✘ ", Warn = "▲ ", Hint = "⚑ ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

