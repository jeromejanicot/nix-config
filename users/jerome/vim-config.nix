{ inputs }:
''
  lua <<EOF

  vim.cmd([[
  syntax enable
  colorscheme dracula
  ]])

  vim.opt.guicursor = ""

  vim.opt.nu = true
  vim.opt.relativenumber = true

  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.expandtab = true

  vim.opt.smartindent = true

  vim.opt.wrap = false

  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
  vim.opt.undofile = true

  vim.opt.hlsearch = false
  vim.opt.incsearch = true

  vim.opt.termguicolors = true

  vim.opt.scrolloff = 8
  vim.opt.signcolumn = "yes"
  vim.opt.isfname:append("@-@")

  vim.opt.updatetime = 50

  vim.opt.colorcolumn = "80"

  -- Clipboard
  vim.keymap.set("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })

  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])
  vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
  vim.keymap.set("n", "<leader>P", [["+P]])

  vim.g.mapleader = " "

  ---------------------------------------------------------------------
  -- Treesitter

  -- Add our treesitter textobjects
  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  }

  require("lspconfig").ts_ls.setup{}
  require("lspconfig").pyright.setup{}
  require("lspconfig").nixd.setup{}

  require("conform").setup({
    formatters_by_ft = {
      cpp = { "clang_format" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      nix = {"nixfmt"}
    },

    format_on_save = {
      lsp_fallback = true,
    },
  })

  ---------------------------------------------------------------------
  -- Gitsigns

  require('gitsigns').setup()

  ---------------------------------------------------------------------
  -- Lualine

  require('lualine').setup({
    sections = {
      lualine_c = {
        { 'filename', path = 1 },
      },
    },
  })

  ---------------------------------------------------------------------
  -- Cinnamon

  -- require('cinnamon').setup()
  -- require('cinnamon').setup {
  --  extra_keymaps = true,
  --  override_keymaps = true,
  --  scroll_limit = -1,
  --}

  vim.opt.termsync = false
  ---------------------------------------------------------------------
  -- fzf
  vim.cmd([[
      let g:fzf_nvim_statusline = 0 " disable statusline overwriting

      nnoremap <silent> <leader><leader>f :Files<CR>
      nnoremap <silent> <leader><leader>rr :Rg<CR>
      nnoremap <silent> <leader><leader>a :Buffers<CR>
      nnoremap <silent> <leader><leader>A :Windows<CR>
      nnoremap <silent> <leader><leader>; :BLines<CR>
      nnoremap <silent> <leader><leader>o :BTags<CR>
      nnoremap <silent> <leader><leader>O :Tags<CR>
      nnoremap <silent> <leader><leader>? :History<CR>
      nnoremap <silent> <leader><leader>/ :execute 'Ag ' . input('Ag/')<CR>
      nnoremap <silent> <leader><leader>. :AgIn

      nnoremap <silent> K :call SearchWordWithAg()<CR>
      vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
      nnoremap <silent> <leader>gl :Commits<CR>
      nnoremap <silent> <leader>ga :BCommits<CR>
      nnoremap <silent> <leader>ft :Filetypes<CR>

      imap <C-x><C-f> <plug>(fzf-complete-file-ag)
      imap <C-x><C-l> <plug>(fzf-complete-line)

      function! SearchWordWithAg()
          execute 'Ag' expand('<cword>')
      endfunction

      function! SearchVisualSelectionWithAg() range
          let old_reg = getreg('"')
          let old_regtype = getregtype('"')
          let old_clipboard = &clipboard
          set clipboard&
          normal! ""gvy
          let selection = getreg('"')
          call setreg('"', old_reg, old_regtype)
          let &clipboard = old_clipboard
          execute 'Ag' selection
      endfunction

      function! SearchWithAgInDirectory(...)
          call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
      endfunction
      command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

      tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

  ]])
  ---------------------------------------------------------------------
  -- Harpoon
  local harpoon = require("harpoon")

  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

  EOF
''
