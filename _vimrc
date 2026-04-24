call plug#begin('~/.vim/bundle')

" Plugins
Plug 'morhetz/gruvbox'            " Gruvbox for Vim
Plug 'plasticboy/vim-markdown'        " Markdown support
Plug 'kazark/vim-log4x'
Plug 'godlygeek/tabular'              " :Tabularize / arg
Plug 'lokaltog/vim-easymotion'        " Because normal movement is slow
Plug 'tpope/vim-fugitive'             " Git from Vim
if has('nvim')
    Plug 'williamboman/mason.nvim'
    Plug 'seblyng/roslyn.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'saghen/blink.cmp', { 'tag': 'v1.*' }
    Plug 'rafamadriz/friendly-snippets'
endif
call plug#end()

filetype indent plugin on
syntax enable

autocmd BufNewFile,BufRead *log* set filetype=log
autocmd BufNewFile,BufRead *log*.txt set syntax=log4x

set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent
set nowrap
set mouse=a
set clipboard=unnamedplus
set backspace=indent,eol,start
set number
set relativenumber
set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" 256 Colors
set t_Co=256
let &t_AB="\e[48;5;%dm"
let &t_AF="\e[38;5;%dm"
set background=dark
colorscheme gruvbox

" Set airline status line
set laststatus=2
let g:airline_section_c = '%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'

" Relative numbers based on mode
augroup linenumbers
  autocmd!
  autocmd BufEnter *    :set relativenumber
  autocmd BufLeave *    :set number norelativenumber
  autocmd WinEnter *    :set relativenumber
  autocmd WinLeave *    :set number norelativenumber
  autocmd InsertEnter * :set number norelativenumber
  autocmd InsertLeave * :set relativenumber
  autocmd FocusLost *   :set number norelativenumber
  autocmd FocusGained * :set relativenumber
augroup END

" Highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Clear search highlight on Esc
nnoremap <Esc> :nohlsearch<CR><Esc>

" Mapleader from \ to space
let mapleader="\<Space>"

" Clear search highlighting on Escape
nmap <Esc> :nohlsearch<CR>

" Use leader for frequently used actions
" <Space>w to save file
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>qq :q!<CR>

" Easy copy paste
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Easymotion (for fast navigation)
map <Leader><Leader> <Plug>(easymotion-prefix)

" File explorer (vim fallback)
if !has('nvim')
    nnoremap <Leader>e :Sexplore<CR>
    nnoremap <Leader>E :Explore<CR>

    " Netrw: open files in previous window instead of split
    let g:netrw_browse_split = 4

    " Reset netrw_chgwin to avoid opening in wrong window after using :Lex
    let g:netrw_chgwin = -1
endif

" LSP configuration (Neovim only)
if has('nvim')
lua << EOF
-- nvim-tree
local nvimtree_ok, nvimtree = pcall(require, 'nvim-tree')
if nvimtree_ok then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    nvimtree.setup({
        diagnostics = {
            enable = true,
        },
        view = {
            width = 40,
        },
    })
    vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<Leader>f', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
end

-- blink.cmp (auto-completion)
local blink_ok, blink = pcall(require, 'blink.cmp')
if blink_ok then
    blink.setup({
        keymap = { preset = 'super-tab' },
        appearance = { nerd_font_variant = 'mono' },
        completion = { documentation = { auto_show = true } },
        sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
    })
end

-- Mason (LSP server installer)
local mason_ok, mason = pcall(require, 'mason')
if mason_ok then
    mason.setup({
        registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
        },
    })
end

-- Roslyn LSP (vim.lsp.config requires nvim 0.11+)
if vim.lsp.config then
    vim.lsp.config('roslyn', {
        on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
        end,
        capabilities = blink_ok and blink.get_lsp_capabilities() or {},
        settings = {
            ['csharp|inlay_hints'] = {
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            },
            ['csharp|code_lens'] = {
                dotnet_enable_references_code_lens = true,
            },
        },
    })

    local roslyn_ok, roslyn = pcall(require, 'roslyn')
    if roslyn_ok then
        roslyn.setup({})
    end
end
EOF
endif
