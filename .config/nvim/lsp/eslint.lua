return {
  cmd      = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { ".eslintrc.json", ".eslintrc.js", "eslint.config.js", "eslint.config.mjs", "package.json" },
  settings  = { validate = "on", run = "onType" },
}
