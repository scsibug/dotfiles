" My neovim config file.
		
syntax on                    " Syntax highlighting

set shortmess=I              " Read :help shortmess for everything else.
set showmatch                " Show matching braces
set mat=1                    " Show matching braces for 1 second
set showcmd                  " Display incomplete commands
set undolevels=1000          " Set number of remembered undos
set number                   " Show line numbers
set cursorline               " Highlight current line
set splitbelow               " Make horiz splits on the bottom
set splitright               " Split on the right
set autoread                 " Auto reload files on change
set smartcase                " Use case sensitive searching if capital is used
set scrolloff=4              " Show 4 lines after the cursor
set expandtab                " Use spaces instead of tabs
set tabstop=4 softtabstop=4  " 4 spaces for tabs
set noerrorbells             " Be quiet
set laststatus=2             " Always display the status line
set incsearch                " Incremental/live searching

" Remaps
" Clear the highlighted area with Ctrl-L
nnoremap <C-L> :nohlsearch<CR><C-L>

" Themes / Colors
"colorscheme molokai " Use the molokai colorscheme
set termguicolors
set background=dark
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
let g:gruvbox_contrast_dark = 'hard'
autocmd vimenter * ++nested colorscheme gruvbox

" Backups/Undos
set noswapfile
set nobackup
if !isdirectory($HOME . "/.nvim-undo")
    call mkdir($HOME . "/.nvim-undo", "p")
endif
set undodir=~/.nvim-undo " Set the undo directory
set undofile " Turn on persistent undo
set undoreload=10000

" Plugins
" Assumes use of vim-plug
call plug#begin(stdpath('data') . '/plugged')

Plug 'morhetz/gruvbox'            " Theme
Plug 'tpope/vim-fugitive'         " Git blame etc.
Plug 'leafgarland/typescript-vim' " Typescript
Plug 'vim-utils/vim-man'
Plug 'git@github.com:kien/ctrlp.vim.git'
Plug 'git@github.com:Valloric/YouCompleteMe.git'
Plug 'mbbill/undotree'
" tabular plugin is used to format tables
Plug 'godlygeek/tabular'
" JSON front matter highlight plugin
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Airplane Mode
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()


" Markdown
" " disable header folding
let g:vim_markdown_folding_disabled = 1
" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0
" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format
