return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "lopi-py/luau-lsp.nvim",
    },
    config = function(_, _)
      require("mason").setup()

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup_handlers({
        luau_lsp = function()
          require("luau-lsp").setup({
            server = {
              filetypes = { "luau" },
              capabilities = vim.lsp.protocol.make_client_capabilities(),
              root_dir = function(path)
                local util = require("lspconfig.util")
                return util.find_git_ancestor(path)
                  or util.root_pattern(
                    ".luaurc",
                    "selene.toml",
                    "stylua.toml",
                    "aftman.toml",
                    "wally.toml",
                    "mantle.yml",
                    "*.project.json"
                  )(path)
              end,
            },
            settings = {
              ["luau-lsp"] = {
                completion = {
                  enabled = true,
                  autocompleteEnd = true,
                },
              },
            },
            types = {
              roblox = true,
            },
            sourcemap = {
              enable = true,
              rojo_path = "rojo",
            },
          })
        end,
      })
      mason_lspconfig.setup({
        ensure_installed = {
          "luau_lsp",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
      setup = {},
    },
    event = {
      "BufReadPre",
      "BufNewFile",
      "BufEnter",
      "BufUnload",
    },
  },
}
