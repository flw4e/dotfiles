return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use({ "joshdick/onedark.vim" })

  use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })
  use({ "kevinhwang91/nvim-bqf" })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "liuchengxu/vista.vim" })
  use({ "machakann/vim-sandwich" })
  use({ "mfussenegger/nvim-dap" })
  use({ "neovim/nvim-lspconfig" })
  use({ "norcalli/nvim-colorizer.lua" })
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
  })
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "sheerun/vim-polyglot" })
  use({ "tpope/vim-fugitive" })
  use({ "tpope/vim-vinegar" })
  use({ "windwp/nvim-autopairs" })
  use({ "Yggdroot/indentLine" })
  use({ "nvim-lualine/lualine.nvim" })
  use({
    "renerocksai/telekasten.nvim",
    requires = {
      {"renerocksai/calendar-vim"},
      {"nvim-telescope/telescope-symbols.nvim"},
      {"nvim-telescope/telescope-media-files.nvim"},
      {"iamcco/markdown-preview.nvim"},
    },
 })
end)
