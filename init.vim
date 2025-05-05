" 9c8c5e4019d05aa19a89d103fb162031a67ef612

" dependencies
" neovim
" python: pynvim, neovim-remote, ruff, yapf
" nodejs: neovim, tree-sitter-cli
" git
" build-essential
" ripgrep
" nerd font
" clipboard provider


" multibyte charsets
set fileencodings=ucs-bom,utf-8,gb18030,gbk,cp936,gb2312,latin1
set ambiwidth=double
call setcellwidths([
    \ [0x0391, 0x03A9, 1],
    \ [0x03B1, 0x03C9, 1],
    \ [0x00ac, 0x00ac, 1],
    \ [0x2423, 0x2423, 1],
    \ [0x2588, 0x2588, 1],
    \ [0x258f, 0x258f, 1],
    \ [0x2591, 0x2593, 1],
    \ [0x25e6, 0x25e6, 1],
  \ ])
set formatoptions+=mM nojoinspaces

let mapleader = ' '
let g:python3_host_prog='python'

" plugins
" default plug path: `stdpath('data') . '/plugged'`
call plug#begin()
Plug 'junegunn/vim-plug'

Plug 'sainnhe/gruvbox-material'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_foreground = 'original'
let g:gruvbox_material_statusline_style = 'original'
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = 1
" termux only supports fonts from a single file
let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_disable_italic_comment = 1

let g:gruvbox_material_transparent_background = 0
let g:gruvbox_material_dim_inactive_windows = 1
let g:gruvbox_material_visual = 'blue background'
let g:gruvbox_material_current_word = 'reverse'
let g:gruvbox_material_menu_selection_background = 'purple'
let g:gruvbox_material_spell_foreground = 'colored'
let g:gruvbox_material_diagnostic_text_highlight = 1

Plug 'catgoose/nvim-colorizer.lua'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'RRethy/vim-illuminate'
" <A-p> & <A-n>: move previous/next reference
" <A-i>: select the cursor-text-object
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = -1

Plug 'godlygeek/tabular'
Plug 'LunarWatcher/auto-pairs', {'tag': 'v4.1.0'}
let g:AutoPairsDefaultDisableKeybinds = 1
let g:AutoPairsCompatibleMaps = 0  " recommended
let g:AutoPairsPrefix = ""
let g:AutoPairsShortcutToggle = ""
let g:AutoPairsShortcutToggleMultilineClose = ""
let g:AutoPairsShortcutJump = ""
let g:AutoPairsShortcutBackInsert = ""
let g:AutoPairsShortcutIgnore = ""
let g:AutoPairsMoveExpression = ""
" <BS>
let g:AutoPairsMapBS = 1
let g:AutoPairsMultilineBackspace = 1
let g:AutoPairsBSAfter = 1
let g:AutoPairsBSIn = 1
" <CR>
let g:AutoPairsMapCR = 0
" <Space>
let g:AutoPairsMapSpace = 1
" expand management
let g:AutoPairsCompleteOnlyOnSpace = 0
let g:AutoPairsSingleQuoteMode = 0
autocmd FileType python let b:AutoPairsSingleQuoteMode = 2
" balance management
let g:AutoPairsPreferClose = 1
let g:AutoPairsMultilineClose = 1
let g:AutoPairsMultilineCloseDeleteSpace = 1
let g:AutoPairsSearchCloseAfterSpace = 1
let g:AutoPairsStringHandlingMode = 0  " since syntax is killed by treesitter
" jump
let g:AutoPairsNoJump = 0
" fast wrap
let g:AutoPairsShortcutFastWrap = "<C-l>"
let g:AutoPairsMultilineFastWrap = 1
let g:AutoPairsMultibyteFastWrap = 1

Plug 'psliwka/vim-smoothie'
Plug 'smoka7/hop.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSInstall all'}
" highlight, indent and fold

Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
let g:coc_global_extensions = [ 'coc-json', 'coc-lists', 'coc-markdownlint',
            \ 'coc-pyright', 'coc-snippets', 'coc-word' ]

" key mappings
function s:check_backspace() abort
    let col_ = col('.') - 1
    return !col_ || getline('.')[col_ - 1] =~# '\s'
endfunction
inoremap <silent><expr> <Tab>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ <SID>check_backspace() ? "\<Tab>" : coc#refresh()
imap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-d>"
" <C-g>u breaks undo chain at current position
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    \: "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>s <Plug>(coc-declaration)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>t <Plug>(coc-type-definition)
nmap <silent> <leader>r <Plug>(coc-references)
nmap <leader>n <Plug>(coc-rename)

nnoremap <silent> K <Cmd>call <SID>show_doc()<CR>
function s:show_doc()
    if CocAction('hasProvider', 'hover') | call CocActionAsync('doHover')
    else | call feedkeys('K', 'in') | endif
endfunction

" map function and class text-object
" requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
imap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Nop>"
imap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Nop>"

" snippets and signature
" autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
imap <silent> <C-h> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
vmap <silent> <C-h> <Cmd>call CocActionAsync('showSignatureHelp')<CR>
let g:coc_snippet_prev = '<C-k>'
let g:coc_snippet_next = '<C-j>'
vmap <C-x> <Plug>(coc-snippets-select)

" coc-lists
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> \e <Cmd>CocList diagnostics<CR>
nmap <silent> \s <Cmd>CocList symbols<CR>
nmap <silent> \f <Cmd>CocList files<CR>
nmap <silent> \g <Cmd>CocList grep<CR>
nnoremap <silent> <leader>g :exe 'CocList -A --no-quit -I --input=\b'.expand('<cword>').'\b grep -F -e'<CR>
nmap <silent> \l <Cmd>CocList lines<CR>
nmap <silent> \m <Cmd>CocList mru<CR>

" command and autocmd
command Format :call CocActionAsync('format')
command Or :call CocActionAsync('runCommand', 'editor.action.organizeImport')
autocmd FileType python nmap <buffer> <leader>v :call CocAction('showOutline', 1)<CR>

" statusline
set statusline=%#StatusLine#%(%y\ %)%<%f%(\ %h%m%r%)
set statusline+=%#Label#%=%(%.50{TruncatedCocStatus(50)}\ \|\ %)
set statusline+=%#Function#%(%{get(b:,'coc_current_function','')}\ \|\ %)
set statusline+=%#CocErrorSign#%-4.{CocDiagnosticsStatus('error')}
set statusline+=%#CocWarningSign#%-4.{CocDiagnosticsStatus('warning')}
set statusline+=%#CocInfoSign#%-4.{CocDiagnosticsStatus('information')}
set statusline+=%#CocHintSign#%-4.{CocDiagnosticsStatus('hint')}
set statusline+=%#StatusLine#%-14.(%l,%c%V%)\ %P

function TruncatedCocStatus(max_len)
    let info = get(g:, 'coc_status', '')
    if len(info) > a:max_len
        return info[:a:max_len / 2 - 1 - 2] .. '....'
                \ .. info[-(a:max_len - a:max_len / 2 - 2):]
    else
        return info
    endif
endfunction

function CocDiagnosticsStatus(key)
    let info = get(b:, 'coc_diagnostic_info', {})
    let signs = {'error': '', 'warning': '', 'information': '', 'hint': ''}
    if !empty(info) && get(info, a:key, 0)
        return signs[a:key] . ' ' . info[a:key]
    else | return ' ' | endif
endfunction
autocmd User CocStatusChange redrawstatus

" manage workspace folders `:h coc-workspace`
" 1. `:CocList folders` lists workspace folders, supports `delete` and `edit`
" 2. `:echo coc#util#root_patterns()` gets patterns used for resolve workspace
"    folder of current buffer
" 3. `g:WorkspaceFolders` stores workspace folders
" to enable multiple workspace folders, open at least one file of each folder

call plug#end()

" autopairs
call autopairs#Variables#InitVariables()
let g:AutoPairs = autopairs#AutoPairsDefine([
    \ {"open": '（', "close": '）'},
    \ {"open": '【', "close": '】'},
    \ {"open": '‘', "close": '’'},
    \ {"open": '“', "close": '”'},
    \ {"open": '《', "close": '》'},
    \ {"open": "$", "close": "$", "filetype": ["tex", "markdown"]},
    \ ])

" set by lua
if has('termguicolors') | set termguicolors | endif
lua << EOF
require("colorizer").setup({
    filetypes = { "*" },
    user_commands = false,
    names = true,
    names_opts = { -- options for mutating/filtering names.
        lowercase = true, -- name:lower(), highlight `blue` and `red`
        camelcase = true, -- name, highlight `Blue` and `Red`
        uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
        strip_digits = false, -- ignore names with digits,
        -- highlight `blue` and `red`, but not `blue3` and `red4`
    },
    RGB = false, -- #RGB hex codes
    RGBA = false, -- #RGBA hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    RRGGBBAA = false, -- #RRGGBBAA hex codes
    AARRGGBB = false, -- 0xAARRGGBB hex codes
})
require('illuminate').configure({
    providers = {
        -- 'lsp',
        -- 'treesitter',
        'regex',
    },
    delay = 100,
    -- `:help mode()`, Normal and Terminal modes
    -- flicker when enter and quit Operator-pending modes
    -- seems that Operator-pending modes will block Vim
    modes_allowlist = { 'n', 't', 'nt', 'ntT', },
})
require'hop'.setup {
    case_insensitive = false,
    jump_on_sole_occurrence = false,
    multi_windows = false,
}
require'nvim-treesitter.configs'.setup {
    sync_install = true,
    auto_install = false,
    prefer_git = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,  -- will disable syntax
    },
    indent = { enable = true },
}
EOF

map s <Cmd>HopChar2<CR>
map <leader>l <Cmd>HopLine<CR>
map <leader>j <Cmd>HopVerticalAC<CR>
map <leader>k <Cmd>HopVerticalBC<CR>

call coc#config('python', {'pythonPath': g:python3_host_prog})
call coc#config('snippets', {'userSnippetsDirectory' : stdpath('config').'/ultisnips'})

" vim builtin plugins
let g:loaded_netrw       = 0
let g:loaded_netrwPlugin = 0
let g:loaded_tar         = 0
let g:loaded_tarPlugin   = 0
let g:loaded_zip         = 0
let g:loaded_zipPlugin   = 0
let loaded_gzip          = 0
" plugins `editorconfig`, `man.lua` and `matchit` are enabled by default

" ui and font
set background=dark
" `LineNr`: bg = SpecialKey's fg, fg = Normal's bg
" be sure that ColorColumn and CursorLine/CursorColumn have the same highlight
function s:gruvbox_material_custom()
    let palette = gruvbox_material#get_palette(
        \ g:gruvbox_material_background,
        \ g:gruvbox_material_foreground, {})
    call gruvbox_material#highlight('LineNr', palette.bg0, palette.bg5, 'bold')
    call gruvbox_material#highlight('CursorLineNr', palette.fg0, palette.bg0, 'bold')
    call gruvbox_material#highlight('CursorLine', palette.none, palette.bg_visual_blue)
    call gruvbox_material#highlight('CursorColumn', palette.none, palette.bg_visual_blue)
    call gruvbox_material#highlight('ColorColumn', palette.none, palette.bg_visual_blue)

    call gruvbox_material#highlight('CocVirtualText', palette.bg5, palette.none)
    call gruvbox_material#highlight('VirtualTextError', palette.grey2, palette.bg_visual_red, 'underline')
    call gruvbox_material#highlight('VirtualTextWarning', palette.grey2, palette.bg_visual_yellow, 'underline')
    call gruvbox_material#highlight('VirtualTextInfo', palette.grey2, palette.bg_visual_blue, 'underline')
    call gruvbox_material#highlight('VirtualTextHint', palette.grey2, palette.bg_visual_green, 'underline')

    call gruvbox_material#highlight('HighlightedyankRegion', palette.none, palette.bg_diff_blue)
endfunction
augroup GruvboxMaterialCustom
    autocmd!
    autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END
colorscheme gruvbox-material

lua << EOF
require("ibl").setup {
    viewport_buffer = { min = 1024 },
    indent = {
        char = "▏",
        highlight = {
            "Purple", "Blue", "Aqua", "Green", "Yellow", "Orange", "Red",
        },
        repeat_linebreak = false,
    },
    whitespace = { remove_blankline_trail = false },
    scope = { enabled = false },
}
EOF

" layout
set title
set signcolumn=number number norelativenumber numberwidth=3
set colorcolumn=81 nocursorline
set laststatus=2
set noruler  " since it's redefined

" movement
set scrolloff=0 nostartofline
set virtualedit=block
set jumpoptions=view

" text display
set wrap nolinebreak breakindent showbreak=\|~>
" turn off physical line wrapping (automatic insertion of newlines)
set textwidth=0 wrapmargin=0
autocmd FileType * setlocal textwidth=0
autocmd FileType * setlocal wrapmargin=0

set display=lastline,uhex conceallevel=0
" ◦␣¬░▒▓█
set list listchars=space:◦,trail:█,eol:¬,nbsp:␣

set nospell spelllang=en,cjk
set showmatch

" other info
set wildmenu wildmode=longest,full
set report=0
set shortmess-=F shortmess+=mrI
set belloff=
silent! aunmenu PopUp.-1-
silent! aunmenu PopUp.-2-
silent! aunmenu PopUp.Inspect
silent! aunmenu PopUp.How-to\ disable\ mouse
" copy and paste with system clipboard
set clipboard=unnamedplus

" dir and files
set autochdir noautoread
set updatetime=200
set backup undofile backupdir-=.

" some keys' behaviors
set nosmarttab expandtab shiftround
autocmd FileType * set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType c,cpp,json,jsonc,yaml
    \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
set backspace=indent,eol,start
set mouse=a mousemodel=popup mousehide
set mousescroll=ver:2,hor:4

" key mappings
" movement
" horizontal
map <leader>a ^
map <leader>e $
" hold selection when shifting sidewards
xnoremap < <gv
xnoremap > >gv
" vertical
" j/k will move over virtual lines (lines that wrap)
noremap <expr> j  (v:count == 0 ? 'gj' : 'j')
noremap <expr> k  (v:count == 0 ? 'gk' : 'k')
map <expr> <Down> (v:count == 0 ? 'gj' : 'j')
map <expr> <Up>   (v:count == 0 ? 'gk' : 'k')
imap <Down> <C-o>gj
imap <Up> <C-o>gk
" search smartly, centrally and smoothly
nnoremap n <Cmd>call feedkeys('Nn'[v:searchforward], 'n')<Bar>call feedkeys('zz')<CR>
nnoremap N <Cmd>call feedkeys('nN'[v:searchforward], 'n')<Bar>call feedkeys('zz')<CR>
nnoremap * <Cmd>call feedkeys('*', 'n')<Bar>call feedkeys('zz')<CR>
nnoremap # <Cmd>call feedkeys('#', 'n')<Bar>call feedkeys('zz')<CR>
" switch between windows, buffers and tabpages
" cf. `CTRL-W_p`
nmap gw <C-w>w
nmap gW <C-w>W
nmap gr <C-w>r
nmap gR <C-w>R
nmap gb <Cmd>bnext<CR>
nmap gB <Cmd>bprevious<CR>
" `gt` and `gT` for tabpages by default

" insert and terminal
imap <C-Tab> <C-t>
" In Terminal mode, type `<C-\><C-n>` to enter Normal mode
" NOTE: Some processes really rely on `<Esc>`, e.g. Neovim nested in Terminal
tnoremap <Esc> <C-\><C-n>

" other
nmap <leader><leader> <C-l>
nmap <leader>o <Cmd>only<CR>
nmap <leader>p <Cmd>setlocal spell!<CR>

nmap \c /\<TODO\>\\|\<NOTE\>\\|\<XXX\>\\|\<FIX\>\\|\<FIXME\>\\|\<BUG\><CR>
nmap \w / \+$\\|[^^ ]\zs \{2,}<CR>
autocmd FileType python nmap <buffer> \w / \+$\\|[^^ ]\zs \{2,}\ze[^#]<CR>
autocmd FileType vim nmap <buffer> \w / \+$\\|[^^ ]\zs \{2,}\ze[^"]<CR>

" Neovim's default mappings
" nnoremap Y y$
" nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>
" inoremap <C-U> <C-G>u<C-U>
" inoremap <C-W> <C-G>u<C-W>
" xnoremap * y/\V<C-R>"<CR>
" xnoremap # y?\V<C-R>"<CR>
" nnoremap & :&&<CR>

" highlight
set pumblend=0 winblend=0
hi MatchParen ctermbg=24 guibg=#005F87
hi Search ctermfg=15 ctermbg=32 guifg=#FFFFFF guibg=#0087D7
hi Cursor cterm=None gui=None ctermbg=36 guibg=#00BF9F

" highlight for treesitter
hi @variable.parameter ctermfg=DarkCyan guifg=DarkCyan

" highlight for markdown
hi! link @text.title1 markdownH1
hi! link @text.title2 markdownH2
hi! link @text.title3 markdownH3
hi! link @text.title4 markdownH4
hi! link @text.title5 markdownH5
hi! link @text.title6 markdownH6
hi! link @text.quote Comment

let g:tex_flavor = "latex"

command DiffOrig
    \ let s:temp_ft=&ft | vert new | set buftype=nowrite | read ++edit #
    \ | silent 0d_ | let &ft=s:temp_ft | diffthis | wincmd p | diffthis
" When editing a file, always jump to the last known cursor position. Don't do
" it when the position is invalid, when inside an event handler (happens when
" dropping a file on gvim) and for a commit message (it's likely a different
" one than last time).
" add `b:jumped` for neovim-remote
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$")
    \ && &ft !~# "commit\|rebase" && !exists('b:jumped')
    \ | exe "normal! g`\"" | call feedkeys('zzzv', 'n') | let b:jumped = 1 | endif

" tips
" user config dir `:echo stdpath('config')`
autocmd BufRead coc-settings.json set filetype=jsonc
command Vimrc execute('CocConfig') | vsplit $MYVIMRC
command HtmlColorNames exec 'tabe ' .. stdpath("config") .. '/mds/HtmlColorNames.md'
" vim can't distinguish between `<Tab>` and `<C-i>`, `<Esc>` and `<C-[>`

" `:TOhtml`
" `:echo synIDattr(synID(line('.'), col('.'), 1), 'name')` or just `:Inspect`
" diff jump: [c ]c
" spell jump: [s ]s
" spell suggest: z=
