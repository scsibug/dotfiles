" My neovim config file.
		
syntax on                    " Syntax highlighting

set nohlsearch               " Don't highlight searches
set shortmess=I              " Read :help shortmess for everything else.
set showmatch                " Show matching braces
set mat=1                    " Show matching braces for 1 second
set showcmd                  " Display incomplete commands
set undolevels=1000          " Set number of remembered undos
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

" File type identification
filetype plugin indent on

" Line numbering
set number relativenumber
" Dynamically toggle between abs/rel line numbering based on focus
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

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
" Rust
Plug 'neovim/nvim-lspconfig'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
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

" Rust LSP
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Use tab for completion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" Code actions
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes
" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '⇒ ', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}

