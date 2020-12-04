" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/ShowTrailingWhitespace'
Plug 'airblade/vim-gitgutter'
Plug 'lambdalisue/fern.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'plasticboy/vim-markdown'
Plug 'neomake/neomake'
Plug 'Shougo/echodoc.vim'
Plug 'junegunn/fzf.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'vim-python/python-syntax'
Plug 'dag/vim-fish'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'easymotion/vim-easymotion'
Plug 'jiangmiao/auto-pairs'
call plug#end()
" }}}

set shell=/bin/bash

let mapleader=" "

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

" Display {{{
syntax on

colorscheme gruvbox
set background=dark

highlight ShowTrailingWhitespace ctermbg=1
highlight Normal ctermbg=none
highlight NonText ctermbg=none

highlight VertSplit ctermbg=none

highlight LineNr ctermfg=242 ctermbg=237

set listchars=tab:▸\ ,trail:·,eol:¶

autocmd WinEnter * setlocal cursorline
autocmd BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
setlocal cursorline

" show mode with cursor shape
set noshowmode
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

function! Statusline(active)
    " para ver los colores: :so $VIMRUNTIME/syntax/hitest.vim
    let stat=''
    let stat.='%#'.(a:active ? 'PmenuSel' : 'StatusLine').'#'
    let stat.=' %t ' " filename
    let stat.='%<' " truncate here
    let stat.='%#'.(a:active ? 'PmenuThumb' : 'StatusLineNC').'#'
    let stat.='%{&readonly ? " - " : ""}'
    let stat.='%#'.(a:active ? 'IncSearch' : 'StatusLineNC').'#'
    let stat.='%{&modified ? " + " : ""}'
    let stat.='%#'.(a:active ? 'StatusLine' : 'StatusLineNC').'#'
    let stat.='%=' " separator
    let stat.='[%{&fileformat}] [%{&fileencoding}] [%{(&expandtab?"s":"t").":".&tabstop}] '
    let stat.='%#'.(a:active ? 'PmenuSel' : 'StatusLine').'#'
    let stat.=' %c:%l/%L '
    let stat.='%#'.(a:active ? 'ErrorMsg' : 'StatusLineNC').'#'
    let stat.='%{neomake#statusline#LoclistStatus()}'
    return stat
endfunction

set statusline=%!Statusline(1)

augroup status
    autocmd!
    autocmd WinEnter * setlocal statusline=%!Statusline(1)
    autocmd WinLeave * setlocal statusline=%!Statusline(0)
augroup END

" show quickfix/location windows always at the bottom
autocmd FileType qf wincmd J
" }}}
" plugin/echodoc {{{
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
" }}}
" plugin/vim-go {{{
let g:go_doc_popup_window = 1
let g:go_highlight_string_spellcheck = 0
let g:go_diagnostics_enabled = 0 " neomake
let g:go_highlight_diagnostic_errors = 0 " neomake
let g:go_highlight_diagnostic_warnings = 0 " neomake

function VimGo_maps()
    nnoremap <silent> <buffer> gr :GoReferrers<CR>
    nnoremap <silent> <buffer> <RightMouse> <LeftMouse>:GoDoc<CR>
    nnoremap <buffer> <Leader>i :GoImports<CR>
    nnoremap <buffer> <Leader>t :GoDefType<CR>
    nnoremap <F7> :call go#lsp#Exit()<CR>
endfunction
autocmd BufEnter *.go call VimGo_maps()
" }}}
" plugin/fzf {{{
let $FZF_DEFAULT_COMMAND = 'command ag -l'
let $FZF_DEFAULT_OPTS = '--layout=reverse  --info=inline'
let g:fzf_layout = { 'window': {
    \ 'width': 0.90,
    \ 'height': 0.90,
    \ 'highlight': 'Identifier',
    \ 'border': 'rounded'
\ }}
nnoremap <silent> <C-P> :FZF<CR>
nnoremap <C-S-f> :Ag \b<C-r>=expand('<cword>')<CR>\b

imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" }}}
" plugin/neomake {{{
call neomake#configure#automake('rw', 0)
let g:neomake_verbose = 0
let g:neomake_python_enabled_makers = ['python']
let g:neomake_c_enabled_makers = ['gcc', 'clangtidy', 'clangcheck']
let g:neomake_c_gcc_args = ['-fsyntax-only', '-std=c99', '-pedantic', '-Wall']

hi link NeomakeVirtualtextInfo GruvboxBlue
hi link NeomakeVirtualtextMessage GruvboxYellow
hi link NeomakeVirtualtextWarning GruvboxOrange
hi link NeomakeVirtualtextError GruvboxRed

hi link NeomakeInfoSign GruvboxBlueSign
hi link NeomakeMessageSign GruvboxYellowSign
hi link NeomakeWarningSign GruvboxOrangeSign
hi link NeomakeErrorSign GruvboxRedSign
" }}}
" plugin/vim-markdown {{{
let g:vim_markdown_folding_disabled = 1
" }}}
" plugin/fern {{{
" Disable netrw
""  let g:loaded_netrw             = 1
""  let g:loaded_netrwPlugin       = 1
""  let g:loaded_netrwSettings     = 1
""  let g:loaded_netrwFileHandlers = 1

""  augroup my-fern-hijack
""    autocmd!
""    autocmd BufEnter * ++nested call s:hijack_directory()
""  augroup END

""  function! s:hijack_directory() abort
""    let path = expand('%:p')
""    if !isdirectory(path)
""      return
""    endif
""    bwipeout %
""    execute printf('Fern %s', fnameescape(path))
""  endfunction

let g:fern#disable_default_mappings = 1

function! s:init_fern() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)<F12>",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer> <Right> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <Left> <Plug>(fern-action-collapse)
  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer> c <Plug>(fern-action-new-path)
  nmap <buffer> <Delete> <Plug>(fern-action-remove)
  nmap <buffer> m <Plug>(fern-action-move)
  nmap <buffer> h <Plug>(fern-action-hidden-toggle)
  nmap <buffer> <C-r> <Plug>(fern-action-reload)
  nmap <buffer> k <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

map <silent> <F12> :Fern . -drawer -toggle<CR>
nmap <silent> <Leader>f :Fern . -drawer -reveal=%<CR>
" }}}
" plugin/gitgutter {{{
set updatetime=500
" }}}
" plugin/python-syntax {{{
let g:python_highlight_all = 1
" }}}
" Indentation {{{
set shiftround  " Round indent to multiple of 'shiftwidth'
set smartindent " Do smart indenting when starting a new line
set autoindent  " Copy indent from current line, over to the new line

function! SetSpaces(w)
    execute "set tabstop=".a:w
    execute "set shiftwidth=".a:w
    execute "set softtabstop=".a:w
    set expandtab
endfunction

function! SetTabs(w)
    execute "set tabstop=".a:w
    execute "set shiftwidth=".a:w
    set softtabstop=0
    set noexpandtab
endfunction

function! TabToggle()
	if &expandtab
        call SetTabs(&tabstop)
	else
        call SetSpaces(&tabstop)
	endif
endfunction

call SetSpaces(4)
" }}}
" Misc shortcuts {{{
nnoremap <Leader>c <C-w>c
nnoremap <Leader><Left> <C-w>v
nnoremap <Leader><Right> <C-w>v<C-w>l
nnoremap <Leader><Down> <C-w>s<C-w>j
nnoremap <Leader><Up> <C-w>s

nnoremap <C-S-Left> <C-w>H
nnoremap <C-S-Right> <C-w>L
nnoremap <C-S-Down> <C-w>J
nnoremap <C-S-Up> <C-w>K
nnoremap <S-Left> <C-w>h
nnoremap <S-Right> <C-w>l
nnoremap <S-Down> <C-w>j
nnoremap <S-Up> <C-w>k
tnoremap <S-Left> <C-\><C-n><C-w>h
tnoremap <S-Right> <C-\><C-n><C-w>l
tnoremap <S-Down> <C-\><C-n><C-w>j
tnoremap <S-Up> <C-\><C-n><C-w>k

nnoremap gw :Window<CR>

nnoremap <S-q> <C-w>c

nmap <F9> mz:execute TabToggle()<CR>'z

map <silent> <C-S> :confirm w<CR>
imap <silent> <C-S> <C-\><C-O>:confirm w<CR>

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

nmap <silent> <Leader>w :set nolist!<CR>

vmap <C-c> "+y
imap <C-v> <C-r>+
"if has('macunix')
"    noremap <C-c> :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
"    imap <C-v> <Esc>:call setreg("\"",system("pbpaste"))<CR>pa
"else
"    vmap <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
"    imap <C-v> <Esc>:call setreg("\"",system("xclip -o -selection clipboard"))<CR>pa
"endif

" move lines around
nnoremap <C-Down> :m+<CR>==
nnoremap <C-Up> :m-2<CR>==
inoremap <C-Down> <Esc>:m+<CR>==gi
inoremap <C-Up> <Esc>:m-2<CR>==gi
vnoremap <C-Down> :m'>+<CR>gv=gv
vnoremap <C-Up> :m-2<CR>gv=gv

" switch line numbers
nmap <silent> <F2> :set nu!<CR>

" This mapping forms a substitute command with the selected text:
vnoremap <C-r> ""y:%s/<C-R>=escape(@", '/\')<CR>//c<Left><Left>

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" select pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

nnoremap & :&&<CR>
xnoremap & :&&<CR>

xnoremap . :normal .<CR>

" goto error
nnoremap ge :ll<CR>
nnoremap ]e :lnext<CR>
nnoremap [e :lprev<CR>

set pastetoggle=<f5>

" Make X an operator that removes text without placing text in the default registry
nmap X "_d
nmap XX "_dd
vmap X "_d
vmap x "_d
nnoremap x "_x
" }}}
" Editor {{{
set nowrap
set showmatch
set title
set history=100
set nomodeline " porque es inseguro

runtime macros/matchit.vim

set shortmess+=c
set completeopt=menuone,noinsert
inoremap <c-space> <c-x><c-o>
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

set backupdir=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set nobackup
set nowritebackup

set exrc
set secure

set mouse=a

noremap <silent> <A-t> :tabnew<CR>
noremap <silent> <A-PageDown> gt
noremap <silent> <A-PageUp> gT
noremap <silent> <A-w> :tabclose<CR>
" }}}
" Folds {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" }}}
" Files {{{
set wildignore=*.o,*.jpg,*.png,*.zip,*/tmp/*

set autoread
au Cursorhold * if expand('%') !=# '[Command Line]' | checktime | endif
au WinEnter * if expand('%') !=# '[Command Line]' | checktime | endif
" }}}
" Autogroups {{{
au BufEnter *.js call SetSpaces(2)
au BufEnter *.json call SetSpaces(2)
au BufEnter *.scss call SetSpaces(2)
au BufEnter *.yml call SetSpaces(2)
au BufEnter *.go call SetTabs(4)
au BufEnter *.md setl tw=79
au BufEnter *.tex setl tw=79
au BufEnter init.vim setl foldmethod=marker
au FileType * setl cinkeys=o,O,!^F indentkeys=o,O,!^F
" }}}
"
nmap <Leader>s <Plug>(easymotion-s2)
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
