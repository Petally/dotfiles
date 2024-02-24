-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })
-- Autoformat luau files with Stylua when saving
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.luau" },
  desc = "Auto-format Luau files after saving",
  callback = function()
    local fileName = vim.fn.expand("%:p")
    vim.cmd(":!stylua " .. fileName)
  end,
  group = autocmd_group,
})
