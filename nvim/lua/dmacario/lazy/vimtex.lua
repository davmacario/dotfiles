return {
  "lervag/vimtex",
  config = function()
    vim.g.tex_flavor = "latex"
    vim.g.tex_conceal = "abdmgs"
    vim.opt.conceallevel = 1
    --vim.g.vimtex_syntax_conceal = 
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
    vim.g.vimtex_view_enabled = 0
    vim.g.vimtex_view_automatic = 0
    vim.g.vimtex_indent_on_ampersands = 0
  end,
}
