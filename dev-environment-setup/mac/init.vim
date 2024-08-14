call plug#begin('~/.config/nvim')

" VIM quality of life stuff
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-vinegar'
Plug 'Sangdol/mintabline.vim'

" Ascii Doc tools
Plug 'habamax/vim-asciidoctor'

" Useful lisp plugins
Plug 'luochen1990/rainbow'

" Conjure server plugin
Plug 'Olical/conjure'

" S-expression plugins
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Editor Config plugin
Plug 'editorconfig/editorconfig-vim'

" Neorg tools
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-neorg/neorg'

" Markdown preview tool
Plug 'ellisonleao/glow.nvim'

" Autocomplete functionality
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Search functionality
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Status line functionality
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Aligning text
Plug 'godlygeek/tabular'

" Maintain nvim layout session
Plug 'tpope/vim-obsession'

" Configurations for nvim language server protocol
Plug 'FullstackGJJ/nvim-lspconfig'
"Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'

""""""""NodeJS development""""""""
Plug 'David-Kunz/cmp-npm'
""""""""""""""""""""""""""""""""""

call plug#end()

set completeopt=menu,menuone,noselect

let g:netrw_banner = 1
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let lightcolors =  ['lightblue', 'lightyellow', 'red', 'darkgreen', 'darkyellow', 'lightred', 'yellow', 'cyan', 'magenta', 'white']
let darkcolors = ['DarkBlue', 'Magenta', 'Black', 'Red', 'DarkGray', 'DarkGreen', 'DarkYellow']
let g:rainbow_conf = {'ctermfgs': lightcolors}

" Setting scheme client with chicken scheme
let g:conjure#client#scheme#stdio#command = "csi -quiet -:c"
let g:conjure#client#scheme#stdio#prompt_pattern = "\n-#;%d-> "

lua <<EOF

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'npm', keyword_length = 4 },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF

lua << END
  require('lualine').setup{
      options = {
          icons_enabled = false,
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '|', right = '|' }
      }
  }
END

lua << EOF
    -- require('neorg').setup {
    --     load = {
    --         ['core.defaults'] = {},
    --         ['core.norg.dirman'] = {
    --             config = {
    --                 workspaces = {
    --                     coding = '~/neorg-coding',
    --                     gtd = '~/neorg-gtd'
    --                 }
    --             }
    --         },
    --         ['core.norg.concealer'] = {},
    --         ['core.export'] = {},
    --         ['core.gtd.base'] = {
    --             config = {
    --                 workspace = 'gtd'
    --             }
    --         },
    --         ['core.norg.manoeuvre'] = {}
    --     }
    -- }
EOF

lua << EOF
  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  require('lspconfig').tsserver.setup {
    capabilities = capabilities
  }
  require('lspconfig').chicken_langserver.setup {
    capabilities = capabilities
  }
EOF

" Using Lua telescope functions "
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" LSP config (the mappings used in the default file don't quite work right) "
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <S-Up> <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> <S-Down> <cmd>lua vim.diagnostic.goto_next()<CR>

" auto-format "
autocmd BufWritePre *.rkt lua vim.lsp.buf.formatting_sync(nil, 100)

:set autoread
:syntax enable 
:syntax on
:filetype plugin indent on
:set encoding=utf-8
:set ruler number relativenumber
:set hlsearch
:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
:set autoindent
:set pastetoggle=<f5>
:set incsearch
:set winminwidth=20
:set winwidth=100
:set winminheight=1
:set winheight=55
:set shortmess-=S
:colorscheme peachpuff " for solarized light
" :colorscheme desert " for solarized dark "
 nnoremap <F5> :checktime<CR>

call setreg('z',':set nonumber:set norelativenumber','c')
call setreg('x',':set number:set relativenumber','c')
call setreg('i','$ik$','c') "for scheme coding convenience of unwrapping grouped up braces
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>
noremap <S-W> :w<CR>
noremap <S-Right> gt
noremap <S-Left> gT
noremap <Right> l
noremap <Left> h
noremap <Up> k
noremap <Down> j
noremap <leader>t vlT
map <Space> <Plug>(easymotion-s)
map <leader><Space> <Plug>(easymotion-prefix)
vnoremap // y/<C-R>"<CR>
vnoremap <C-N> :normal 
vnoremap <C-C> "+y
vnoremap <C-K> :call FocusRange()<CR>:<BS>

function! FocusRange() range
    if a:firstline > 1
        let aboveLine = a:firstline - 1
    else
        let aboveLine = 1
    endif
    if a:lastline < line('$')
        let belowLine = a:lastline + 1
    else
        let belowLine = line('$')
    endif
    :execute ":1," . aboveLine . "fold"
    :execute ":" . belowLine . "," . line('$') . "fold"
endfunction

function! SortWordsInLine()
    :call setline('.', join(sort(split(getline('.'), ' ')), " "))
endfunction

function! VimConfig()
    :tabnew $MYVIMRC
endfunction

function! TmuxConfig()
    :tabnew ~/.tmux.config
endfunction

function! ZshConfig()
    :tabnew ~/.zshrc
endfunction

function! JQ()
    :%!jq '.'
endfunction
