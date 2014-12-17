" Switch syntax highlighting on
syntax on

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
