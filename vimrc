" Install plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Map Leader to space
nnoremap <Space> <Nop>
let mapleader="\<SPACE>"

" Install plug plugins
call plug#begin()

Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'JamshedVesuna/vim-markdown-preview'

call plug#end()

" Show relative numbers with the current line number
set relativenumber number

" Update faster for git gutter
set updatetime=100

" Use Dracula theme
syntax on
color dracula
let g:airline_theme='dracula'

" always show ruler at bottom
set ruler

" don't make foo~ files
set nobackup

" searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" indentation
set autoindent
set smarttab
if has("autocmd")
  filetype on
  filetype indent on
  filetype plugin on
endif

" whitespace
if has("multi_byte")
  set encoding=utf-8
  set list listchars=tab:»·,trail:·
else
  set list listchars=tab:>-,trail:.
endif

" disable mouse integration
set mouse=

" Open NERDTree with ctrl+n
map <C-n> :NERDTreeToggle<CR>

" Show hidden files in NERDTree
let NERDTreeShowHidden=1

" Mapping easier fzf commands
nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>

" Use grip instead of markdown for preview
let vim_markdown_preview_github=1