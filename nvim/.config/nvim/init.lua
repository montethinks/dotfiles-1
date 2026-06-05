-- init.lua
-- Neovim-first config converted from the user's .vimrc.
-- Goals:
-- 1) Preserve core key behavior and editing feel
-- 2) Modernize plugin management with lazy.nvim
-- 3) Remove dead / overlapping config
-- 4) Keep the config readable and easy to extend

------------------------------------------------------------
-- Bootstrap lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- Leader
------------------------------------------------------------
vim.g.mapleader = ','
vim.g.maplocalleader = ','

------------------------------------------------------------
-- Core options
------------------------------------------------------------
local opt = vim.opt

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.number = true
opt.hidden = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 1000
opt.ttimeoutlen = 0
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.guicursor = 'i:block'

opt.scrolloff = 8
opt.sidescrolloff = 15
opt.sidescroll = 1

opt.splitright = true
opt.splitbelow = true

opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true

opt.textwidth = 78
opt.listchars = {
  trail = '⋅',
  tab = '▸ ',
  eol = '¬',
  extends = '❯',
  precedes = '❮',
}

opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Persistent undo + centralized state dirs
local data_path = vim.fn.stdpath('data')
local state_dirs = {
  data_path .. '/swap//',
  data_path .. '/backup//',
  data_path .. '/undo//',
}
for _, dir in ipairs(state_dirs) do
  vim.fn.mkdir(dir, 'p')
end
opt.directory = data_path .. '/swap//'
opt.backupdir = data_path .. '/backup//'
opt.undofile = true
opt.undodir = data_path .. '/undo//'

------------------------------------------------------------
-- Keymaps that preserve the current workflow
------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Ctrl-L syntax resync / redraw
map('n', '<C-l>', '<C-l>:syntax sync fromstart<CR>', { noremap = true, silent = true })
map('i', '<C-l>', '<Esc><C-l>:syntax sync fromstart<CR>a', { noremap = true, silent = true })

-- Clear highlighted search
map('n', '<CR>', ':nohlsearch<CR>/<BS>', { noremap = true, silent = true })
map('n', '<C-CR>', ':nohlsearch<CR>/<BS>', { noremap = true, silent = true })

-- Visual indent / reselect behavior
map('v', '>', '>gv', opts)
map('v', '<Tab>', '>gv', opts)
map('v', '<', '<gv', opts)
map('v', '<S-Tab>', '<gv', opts)
map('i', '<S-Tab>', '<BS>', opts)

-- Hash rocket
map('i', '<C-h>', ' => ', { noremap = true })

-- Move lines up/down
map('n', '<C-J>', ':m +1<CR>', opts)
map('n', '<C-K>', ':m -2<CR>', opts)

-- Duplicate selection
map('v', 'D', "y'>p", { noremap = true })

-- Reselect last pasted/changed text
map('n', 'gV', function()
  return '`[' .. string.sub(vim.fn.getregtype(), 1, 1) .. '`]'
end, { expr = true, noremap = true })

-- Insert current file path in command mode
map('c', '<C-P>', [[<C-R>=expand('%:p:h') . '/'<CR>]], { noremap = true })

-- Buffer navigation
map('n', '<Leader>l', ':ls<CR>', opts)
map('n', '<Leader>b', ':bp<CR>', opts)
map('n', '<Leader>f', ':bn<CR>', opts)
map('n', '<Leader>g', ':e#<CR>', opts)
for i = 1, 9 do
  map('n', '<Leader>' .. i, ':' .. i .. 'b<CR>', opts)
end
map('n', '<Leader>0', ':10b<CR>', opts)

------------------------------------------------------------
-- lazy.nvim plugins
------------------------------------------------------------
require('lazy').setup({
  { 'nvim-lua/plenary.nvim' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        hijack_cursor = true,
        hijack_directories = { enable = true, auto_open = true },
        sync_root_with_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        renderer = {
          group_empty = true,
          icons = { show = { git = true, folder = true, file = true, folder_arrow = true } },
        },
        view = { width = 34 },
        filters = { dotfiles = false },
      })

      -- Open tree on startup: bare `nvim`, or `nvim .` / `nvim <dir>`
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local arg = vim.fn.argv(0)
          local is_dir = arg ~= '' and vim.fn.isdirectory(arg) == 1
          if vim.fn.argc() == 0 or is_dir then
            vim.cmd('NvimTreeOpen')
            vim.cmd('wincmd p')
          end
        end,
      })
    end,
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  {
    'dense-analysis/ale',
    init = function()
      vim.g.ale_completion_enabled = 1
      vim.g.ale_fix_on_save = 1
      vim.g.ale_floating_preview = 1
      vim.g.ale_ruby_rubocop_executable = 'bin/rubocop'
      vim.g.ale_fixers = {
        javascript = { 'eslint', 'prettier' },
        typescript = { 'eslint', 'prettier' },
        javascriptreact = { 'eslint', 'prettier' },
        typescriptreact = { 'eslint', 'prettier' },
        ruby = { 'rubocop' },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local servers = { 'ts_ls', 'lua_ls', 'ruby_lsp', 'gopls' }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end,
  },

  { 'jparise/vim-graphql', ft = { 'graphql', 'javascript', 'typescript' } },
  { 'pangloss/vim-javascript', ft = { 'javascript', 'javascriptreact' } },
  { 'mxw/vim-jsx', ft = { 'javascript', 'javascriptreact' } },
  { 'fatih/vim-go', ft = { 'go' } },

  {
    'github/copilot.vim',
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_enabled = false
    end,
  },
}, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})

------------------------------------------------------------
-- Plugin config / plugin-related keymaps
------------------------------------------------------------
vim.g.jsx_ext_required = 0
vim.g.vim_markdown_folding_disabled = 1

-- Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fa', '<cmd>Telescope find_files hidden=true<cr>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)

-- ALE / "MDK mappings"
map('n', '<leader>gd', '<cmd>ALEGoToDefinition<cr>', opts)
map('n', '<leader>h', '<cmd>ALEHover<cr>', opts)
map('n', '<leader>an', '<cmd>ALENext<cr>', opts)
map('n', '<leader>af', '<cmd>ALEFindReferences<cr>', opts)

-- Command alias so old muscle memory still works if you type :NERDTreeToggle
vim.api.nvim_create_user_command('NERDTreeToggle', 'NvimTreeToggle', {})

-- Insert-mode completion Tab behavior
map('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  end
  return '<Tab>'
end, { expr = true, noremap = true, silent = true })

-- Copilot accept mapping (kept exactly where practical)
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
  silent = true,
})

------------------------------------------------------------
-- Filetype / syntax
------------------------------------------------------------
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

------------------------------------------------------------
-- Statusline similar to the old one
------------------------------------------------------------
opt.laststatus = 2
opt.statusline = '%02n:%<%f %h%m%r%=%-14.(%l,%c%V%) %P'
