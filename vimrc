" Inspired by this document
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" SimpylFold for improved python folding
" https://github.com/tmhedberg/SimpylFold
Plugin 'tmhedberg/SimpylFold'

" More intelligent python indentation
Plugin 'vim-scripts/indentpython.vim'

" Python autocompletion
Bundle 'Valloric/YouCompleteMe'

" Syntax highlighting
Plugin 'scrooloose/syntastic'

" PEP8 checking
Plugin 'nvie/vim-flake8'

" Nice looking theme
Plugin 'jnurmine/Zenburn'

" git vim plugin
Plugin 'tpope/vim-fugitive'

" json highlighting
Plugin 'elzr/vim-json'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"
" Setup general tab handling
"
set softtabstop=4
set shiftwidth=4
set tabstop=8
set expandtab

" PEP8 indentation for python
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set encoding=utf-8

" YouCompleteMe Modifications:
let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"
" Visualization options.
"
set guifont=dejavu\ sans\ mono\ 8
set ruler
set number
set scrolloff=10
set cursorline
syntax enable
"colorscheme slate " My old favorite
colorscheme zenburn

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

" split navigation
" ctrl-h,j,k,l allow for navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

"python with virtualenv support
python3 << EOF
import os
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    with open(activate_this) as f:
        code = compile(f.read(), activate_this, 'exec')
        exec(code, dict(__file__=activate_this))
EOF

