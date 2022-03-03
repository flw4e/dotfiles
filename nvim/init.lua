local cmd = vim.cmd
local f = require("settings.functions")
local g = vim.g
local map = f.map
local opt = vim.opt
local global_opt = vim.opt_global

cmd([[packadd packer.nvim]])

require("plugins")
require("settings.functions")
require("settings.cmp").setup()
require("settings.telescope").setup()
require("settings.lsp").setup()
require("settings.zettelkasten")
require("nvim-autopairs").setup()
--require("gitsigns").setup()

require("nvim-treesitter.configs").setup({
  playground = { enable = true },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  ensure_installed = "maintained",
--  highlight = {
--    enable = true,
--    disable = { "scala" },
--  },
})

require('lualine').setup( {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},               -- enable mouse support
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{
      'buffers',
      mode = 2
    }},
    lualine_b = {''},
    lualine_c = {''},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  },
  extensions = {
  }

})

----------------------------------
-- COMMANDS ----------------------
----------------------------------
-- LSP
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
cmd([[augroup end]])

-- Need for symbol highlights to work correctly
vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])
----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  serverVersion = "0.10.9+133-9aae968a-SNAPSHOT",
}

-- Example of how to ovewrite a handler
metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = { prefix = "" },
})

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are including snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

metals_config.capabilities = capabilities

-- Debug settings if you're using nvim-dap
local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run",
    metals = {
      runType = "run",
      -- again... example, don't leave these in here
      args = { "firstArg", "secondArg", "thirdArg" },
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test File",
    metals = {
      runType = "testFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end


g["mapleader"] = ","
g["netrw_gx"] = "<cWORD>"


local indent = 2

global_opt.shortmess:remove("F")
global_opt.termguicolors = true
global_opt.hidden = true
global_opt.showtabline = 1
global_opt.updatetime = 300
global_opt.showmatch = true
global_opt.laststatus = 2
global_opt.wildignore = { ".git", "*/node_modules/*", "*/target/*", ".metals", ".bloop", ".ammonite" }
global_opt.ignorecase = true
global_opt.smartcase = true
global_opt.clipboard = "unnamed"
global_opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
global_opt.scrolloff = 5
g["markdown_folding"] = 1
opt.mouse = 'a'
-- window-scoped
opt.wrap = false
opt.cursorline = true
opt.signcolumn = "yes"

-- buffer-scoped
opt.tabstop = indent
opt.shiftwidth = indent
opt.softtabstop = indent
opt.expandtab = true
opt.fileformat = "unix"


-- MAPPINGS -----------------------
map("i", "jj", "<ESC>")

map("n", "<leader><leader>n", [[<cmd>lua RELOAD("settings.functions").toggle_nums()<CR>]])
map("n", "<leader><leader>c", [[<cmd>lua RELOAD("settings.functions").toggle_conceal()<CR>]])

map("n", "<leader>xml", ":%!xmllint --format -<cr>")
map("n", "<leader>fo", ":copen<cr>")
map("n", "<leader>fc", ":cclose<cr>")
map("n", "<leader>fn", ":cnext<cr>")
map("n", "<leader>fp", ":cprevious<cr>")
map("n", "<leader>tv", ":vnew | :te<cr>")

-- LSP
map("n", "<leader>gf", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
map("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
map("v", "K", [[<Esc><cmd>lua require("metals").type_of_range()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
map("n", "gds", [[<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>]])
map("n", "gws", [[<cmd>lua require"settings.telescope".lsp_workspace_symbols()<CR>]])
map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
map("n", "<leader>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
map("n", "<leader>ws", [[<cmd>lua require"metals".hover_worksheet()<CR>]])
map("n", "<leader>a", [[<cmd>lua require("metals").open_all_diagnostics()<CR>]])
map("n", "<leader>tt", [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]])
map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.diagnostic.setloclist()<CR>]]) -- buffer diagnostics only
map("n", "<leader>nd", [[<cmd>lua vim.diagnostic.goto_next()<CR>]])
map("n", "<leader>pd", [[<cmd>lua vim.diagnostic.goto_prev()<CR>]])
map("n", "<leader>ld", [[<cmd>lua vim.diagnostic.open_float(0, {scope = "line"})<CR>]])
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>fc", [[<cmd>lua vim.lsp.buf.formatting()<CR>]])

map("n", "<leader>st", [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]])
map("n", "<leader>oi", [[<cmd>lua require'jdtls'.organize_imports()<CR>]])
map("n", "<leader>crv", [[<cmd>lua require('jdtls').extract_variable()<CR>]])
map("v", "<leader>crv", [[<esc><cmd>lua require('jdtls').extract_variable()<CR>]])
map("n", "<leader>crc", [[<cmd>lua require('jdtls').extract_constant()<CR>]])
map("v", "<leader>crc", [[<esc><cmd>lua require('jdtls').extract_constant()<CR>]])
map("v", "<leader>crm", [[<esc><cmd>lua require('jdtls').extract_method()<CR>]])

-- telescope
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".find_files({layout_strategy="vertical"})<CR>]])
map("n", "<leader>fl", [[<cmd>lua require"telescope".extensions.file_browser.file_browser({layout_strategy="vertical",cwd = vim.fn.expand('%:p:h')})<CR>]])
map("n", "<leader>lg", [[<cmd>lua require"telescope.builtin".live_grep({layout_strategy="vertical"})<CR>]])
map("n", "<leader>bb", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
map("n", "<leader>fb", [[<cmd>lua require"telescope".extensions.file_browser.file_browser({layout_strategy="vertical"})<CR>]])
map("n", "<leader>mc", [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]])
map("n", "<leader>cc", [[<cmd>lua RELOAD("telescope").extensions.coursier.complete()<CR>]])

-- nvim-dap
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dx", [[<cmd>lua require"dap".run()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>ds", [[<cmd>lua require"dap.ui.variables".scopes()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])


-- teleskasten
map("n", "<leader>zf", [[<cmd>lua require('telekasten').find_notes()<CR>]])
map("n", "<leader>zd", [[<cmd>lua require('telekasten').find_daily_notes()<CR>]])
map("n", "<leader>zg", [[<cmd>lua require('telekasten').search_notes()<CR>]])
map("n", "<leader>zz", [[<cmd>lua require('telekasten').follow_link()<CR>]])
map("n", "<leader>zT", [[<cmd>lua require('telekasten').goto_today()<CR>]])
map("n", "<leader>zW", [[<cmd>lua require('telekasten').goto_thisweek()<CR>]])
map("n", "<leader>zw", [[<cmd>lua require('telekasten').find_weekly_notes()<CR>]])
map("n", "<leader>zn", [[<cmd>lua require('telekasten').new_note()<CR>]])
map("n", "<leader>zN", [[<cmd>lua require('telekasten').new_templated_note()<CR>]])
map("n", "<leader>zy", [[<cmd>lua require('telekasten').yank_notelink()<CR>]])
map("n", "<leader>zc", [[<cmd>lua require('telekasten').show_calendar()<CR>]])
map("n", "<leader>zC", [[<cmd>CalendarT<CR>]])
map("n", "<leader>zi", [[<cmd>lua require('telekasten').paste_img_and_link()<CR>]])
map("n", "<leader>zt", [[<cmd>lua require('telekasten').toggle_todo()<CR>]])
map("n", "<leader>zb", [[<cmd>lua require('telekasten').show_backlinks()<CR>]])
map("n", "<leader>zF", [[<cmd>lua require('telekasten').find_friends()<CR>]])
map("n", "<leader>zI", [[<cmd>lua require('telekasten').insert_img_link({ i=true })<CR>]])
map("n", "<leader>zp", [[<cmd>lua require('telekasten').preview_img()<CR>]])
map("n", "<leader>zm", [[<cmd>lua require('telekasten').browse_media()<CR>]])
map("n", "<leader>za", [[<cmd>lua require('telekasten').show_tags()<CR>]])
map("n", "<leader>#", [[<cmd>lua require('telekasten').show_tags()<CR>]])

map("n", "<leader>Z", [[<cmd>lua require('telekasten').panel()<CR>]])

map("i", "[[", [[<cmd>lua require('telekasten').insert_link()<CR>]])
map("i", "<leader>[", [[<cmd>lua require('telekasten').insert_link({ i=true })<CR>]])
map("i", "<leader>zt", [[<cmd>lua require('telekasten').toggle_todo({ i=true })<CR>]])
map("i", "<leader>#", [[<cmd>lua require('telekasten').show_tags({i = true})<cr>]])


-- scala-utils
map("n", "<leader>slc", [[<cmd>lua RELOAD("scala-utils.coursier").complete_from_line()<CR>]])
map("n", "<leader>sc", [[<cmd>lua RELOAD("scala-utils.coursier").complete_from_input()<CR>]])

-- other stuff
require("settings.globals")
map("n", "<leader><leader>p", [[<cmd>lua require"playground.functions".peek()<CR>]])
map("n", "<leader><leader>s", [[<cmd>lua RELOAD("playground.semantic").generate()<CR>]])
map("n", "<leader><leader>m", [[<cmd>lua RELOAD("playground.mt").get_dep()<CR>]])
map("n", "<leader><leader>s", [[<cmd>lua RELOAD("playground.functions").set_ext()<CR>]])
map("n", "<leader><leader>g", [[<cmd>lua RELOAD("playground.functions").get_exts()<CR>]])
map("n", "<leader><leader>e", [[:luafile %<CR>]])
map("n", "<leader><leader>v", [[<cmd>lua RELOAD("playground.functions").get_latest_metals()<CR>]])

map("n", "<leader>nc", [[<cmd>set conceallevel=0<CR>]])


-- navigation
map('n', '<leader>bn', [[:bn<cr>]])
map('n', '§', [[:bn<cr>]])
map('n', '<leader>bp', [[:bp<cr>]])
map('n', '½', [[:bp<cr>]])
cmd([[augroup colorset]])
cmd([[autocmd!]])

--- For some reason when this is included in the augroup down below it doesn't work
---- Needed to esnure float background doesn't get odd highlighting
---- https://github.com/joshdick/onedark.vim#onedarkset_highlight
cmd(
  [[autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" } })]]
)
cmd([[autocmd ColorScheme * highlight link LspCodeLens Conceal]])
cmd([[augroup END]])

cmd("colorscheme onedark")

-- Should link to something to see your code lenses
cmd([[hi! link LspCodeLens CursorColumn]])
-- Should link to something so workspace/symbols are highlighted
cmd([[hi! link LspReferenceText CursorColumn]])
cmd([[hi! link LspReferenceRead CursorColumn]])
cmd([[hi! link LspReferenceWrite CursorColumn]])

-- If you want a :Format command this is useful
cmd([[command! Format lua vim.lsp.buf.formatting()]])


