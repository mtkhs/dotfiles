
vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = false,
})

--
-- Python
--
vim.lsp.config('ruff', {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {
  }
})
if vim.fn.executable('ruff') == 1 then
  vim.lsp.enable('ruff')
end

vim.lsp.config('pyright', {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { 'python' },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off"
      }
    }
  }
})
--if vim.fn.executable('pyright-langserver') == 1 then
--  vim.lsp.enable('pyright')
--end

--
-- bash
--
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh', 'zsh' }
})
if vim.fn.executable('bash-language-server') == 1 then
  vim.lsp.enable('bashls')
end

--
-- Lua
--
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        -- path = { "?.lua", "?/init.lua" },
      },
      diagnostics = {
        globals = { 'vim' },
      }
    }
  }
})
if vim.fn.executable('lua-language-server') == 1 then
  vim.lsp.enable('lua_ls')
end

