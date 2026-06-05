" Modernized vimrc / init.vim-style config
" Keeps existing core key behavior while removing stale / deprecated pieces.

scriptencoding utf-8
set encoding=utf-8

" --------------------------------------------------
" Plugin manager
" --------------------------------------------------
call plug#begin('~/.vim/plugged')

" UI / editing
Plug 'morhetz/gruvbox'
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'github/copilot.vim'

" File tree / search
Plug 'preservim/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind'] }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }

" Language support
Plug 'dense-analysis/ale'
Plug 'jparise/vim-graphql'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'fatih/vim-go'
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

call plug#end()

" --------------------------------------------------
" Leaders
" --------------------------------------------------
let mapleader = ','
let maplocalleader = ','

" --------------------------------------------------
" Core behavior
" --------------------------------------------------
filetype plugin indent on
syntax enable
set hidden
set mouse=a
set clipboard=unnamedplus
set updatetime=250
set timeoutlen=500
set ttimeoutlen=0
set completeopt=menuone,noselect,popup
set wildmode=longest:full,full
set wildignorecase
set confirm
set signcolumn=yes
set number
set scrolloff=8
set sidescrolloff=15
set sidescroll=1
set splitright
set splitbelow
set incsearch
set ignorecase
set smartcase
set hlsearch
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set textwidth=78
set listchars=trail:⋅,tab:▸\ ,eol:¬,extends:❯,precedes:❮
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set background=dark
set termguicolors
set guicursor=i:block
colorscheme gruvbox

" Persistent undo / swap / backup dirs
set noswapfile
if has('persistent_undo')
  set undofile
  let s:undo_dir = expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p')
  endif
  let &undodir = s:undo_dir
endif
let s:swap_dir = expand('~/.vim/swap')
if !isdirectory(s:swap_dir)
  call mkdir(s:swap_dir, 'p')
endif
let &directory = s:swap_dir
let s:backup_dir = expand('~/.vim/backup')
if !isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p')
endif
let &backupdir = s:backup_dir

" --------------------------------------------------
" Keep your muscle-memory mappings
" --------------------------------------------------

" Ctrl-L recolors the screen when it gets confused.
nnoremap <C-l> <C-l>:syntax sync fromstart<CR>
inoremap <C-l> <Esc><C-l>:syntax sync fromstart<CR>a

" Clear highlighted search with Enter / Ctrl-Enter
nnoremap <CR> :nohlsearch<CR>/<BS>
nnoremap <C-CR> :nohlsearch<CR>/<BS>

" Re-select after indenting in visual mode
xnoremap > >gv
xnoremap <Tab> >gv
xnoremap < <gv
xnoremap <S-Tab> <gv
inoremap <S-Tab> <BS>

" Ruby hashrocket shortcut
inoremap <C-h> <Space>=><Space>

" Move lines up and down
nnoremap <C-J> :m .+1<CR>==
nnoremap <C-K> :m .-2<CR>==

" Duplicate a visual selection
xnoremap D y'>p

" Re-select the text that was last edited/pasted
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

" Insert current file path in command mode
cnoremap <C-P> <C-R>=expand('%:p:h') . '/'<CR>

" Buffer navigation
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fa <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
augroup nerdtree_startup
  autocmd!
  autocmd VimEnter * if argc() == 0 | NERDTree | wincmd p | endif
augroup END

" ALE mappings
nnoremap <leader>gd <cmd>ALEGoToDefinition<cr>
nnoremap <leader>h <cmd>ALEHover<cr>
nnoremap <leader>an <cmd>ALENext<cr>
nnoremap <leader>af <cmd>ALEFindReferences<cr>

" Completion behavior: keep Tab muscle memory
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" Copilot
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
let g:copilot_enabled = v:false

" --------------------------------------------------
" Plugin settings
" --------------------------------------------------
let g:jsx_ext_required = 0

" ALE is current and maintained; use it for linting/fixing instead of null-ls.
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_ruby_rubocop_executable = 'bin/rubocop'
let g:ale_fixers = {
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'javascriptreact': ['eslint', 'prettier'],
\   'typescriptreact': ['eslint', 'prettier'],
\   'ruby': ['rubocop'],
\}

" Optional: reduce noise for very large repos
let g:ale_pattern_options = {
\   '.*node_modules/.*': {'ale_enabled': 0},
\}

" --------------------------------------------------
" Small quality-of-life commands
" --------------------------------------------------
command! VimrcEdit execute 'edit' $MYVIMRC
command! VimrcReload source $MYVIMRC | echo 'vimrc reloaded'
