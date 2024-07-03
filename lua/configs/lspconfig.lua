-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
-- local servers = { }

-- Custom on_attach function to disable hover for ruff_lsp
local custom_on_attach = function(client, bufnr)
  if client.name == "ruff_lsp" then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
  -- Call NVChad's on_attach function
  if on_attach then
    on_attach(client, bufnr)
  end
end

-- Setup ruff_lsp with the custom on_attach function
lspconfig.ruff_lsp.setup {
  on_attach = custom_on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "python" },
}

-- Setup Pyright with NVChad's default on_attach function
lspconfig.pyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "python" },
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}

-- For verible
lspconfig.verible.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "verible-verilog-ls", "--rules_config_search" },
}
