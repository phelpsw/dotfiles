set nocp

"
" Automatic file and indent detection
"
filetype plugin indent on

"
" Setup tab handling
"
set softtabstop=4
set shiftwidth=4
set tabstop=8
set expandtab

"
" Visualization options.
"
set guifont=dejavu\ sans\ mono\ 8
set ruler
set number
set scrolloff=10
set cursorline
syntax enable
colorscheme slate

"
" Menu auto complete options 
"
set wildmode=longest,list

"
" Setup extra whitespace highlighting
"
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"
" highlight the 80th column
"
if exists('+colorcolumn')
    set colorcolumn=80
else
    " fallback for Vim < v7.3
    autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif


