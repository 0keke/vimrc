" Options:{{{

if &compatible
  set nocompatible
endif

set encoding=utf-8
set makeencoding=char
scriptencoding utf-8

let $XDG_CACHE_HOME = get(environ(), 'XDG_CACHE_HOME', expand('~/.cache'))
let $VIMHOME = expand('<sfile>:p:h')
let g:mapleader = "\<Space>"

set winaltkeys=yes
set guioptions=mM
set mouse=a
set belloff=all
set clipboard=unnamed

if exists('&termguicolors')
  set termguicolors
endif

set listchars=tab:>-,extends:<,trail:-,eol:<

" Specify number of spaces to use for each step of (auto)indent explicitly.
" Ref:[https://github.com/vim-jp/issues/issues/1031]
set shiftround softtabstop=-1 shiftwidth=2 tabstop=2
set expandtab

set hlsearch incsearch

set ruler
set rulerformat=%{&fileencoding}/%{&fileformat}
set showmatch matchtime=1
set wildmenu
set shortmess& shortmess-=S

" see: *default.vim*
set timeout ttimeoutlen=50

if has('persistent_undo')
  silent! call mkdir(expand('$XDG_CACHE_HOME/vim/undo'), 'p')
  set undofile undodir=$XDG_CACHE_HOME/vim/undo//
endif

if has('viminfo')
  set viminfo& viminfo+=n$XDG_CACHE_HOME/vim/viminfo
endif

let g:vim_indent_cont = &g:shiftwidth

if executable('rg')
  if executable('jq')
    let &grepprg = 'rg --json $* \| jq -r ''select(.type=="match")\|.data as $data\|$data.submatches[]\|"\($data.path.text):\($data.line_number):\(.start+1):\(.end+1):\($data.lines.text//""\|sub("\n$";""))"'''
    set grepformat=%f:%l:%c:%k:%m
  else
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
    set grepformat=%f:%l:%c:%m
  endif
endif

"}}}

" Plugins:{{{

function! PackInit() abort
  call s:ensure_minpac()

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('vim-jp/syntax-vim-ex')
  call minpac#add('tyru/open-browser.vim')
  call minpac#add('thinca/vim-qfhl')

  " https://twitter.com/mattn_jp/status/1526718582264320000
  call minpac#add('rbtnn/vim-ambiwidth')

  call minpac#add('tyru/caw.vim')
  call minpac#add('machakann/vim-sandwich')
  call minpac#add('andymass/vim-matchup')
  " call minpac#add('itchyny/vim-parenmatch')

  call minpac#add('kana/vim-operator-user')
  call minpac#add('kana/vim-textobj-user')
  call minpac#add('haya14busa/vim-operator-flashy')

  call minpac#add('mattn/vim-molder')
  " call minpac#add('lambdalisue/fern-hijack.vim')
  call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
  call minpac#add('lambdalisue/fern.vim')
  call minpac#add('lambdalisue/glyph-palette.vim')
  call minpac#add('lambdalisue/nerdfont.vim')

  call minpac#add('mattn/vim-lsp-settings')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('tsuyoshicho/vim-efm-langserver-settings')

  call minpac#add('t9md/vim-quickhl')
  call minpac#add('lambdalisue/gina.vim')
  call minpac#add('previm/previm')
  call minpac#add('ntpeters/vim-better-whitespace')
  call minpac#add('bfrg/vim-qf-preview')

  " color scheme
  call minpac#add('NLKNguyen/papercolor-theme')
  call minpac#add('cocopon/iceberg.vim')
  call minpac#add('gilgigilgil/anderson.vim')
  call minpac#add('habamax/vim-habamax')
  call minpac#add('sainnhe/edge')
  call minpac#add('tomasr/molokai')
endfunction

function! s:ensure_minpac() abort
  let url = 'https://github.com/k-takata/minpac'
  let dir = expand('$VIMHOME/pack/minpac/opt/minpac')
  if !isdirectory(dir)
    silent execute printf('!git clone --depth 1 %s %s', url, dir)
  endif
  packadd minpac
endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

function! PackList(...)
  call PackInit()
  return join(sort(keys(minpac#getpluglist())), "\n")
endfunction

command! -nargs=1 -complete=custom,PackList
  \ PackOpenDir call PackInit() | call term_start(&shell,
  \    {'cwd': minpac#getpluginfo(<q-args>).dir,
  \     'term_finish': 'close'})

command! -nargs=1 -complete=custom,PackList
  \ PackOpenUrl call PackInit() | call openbrowser#open(
  \    minpac#getpluginfo(<q-args>).url)

"}}}

" Netrw: {{{
let g:netrw_home = expand('$XDG_CACHE_HOME/netrw')
" }}}

" OpenBrowser: {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

" vim-lsp:{{{
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc')
    setlocal tagfunc=lsp#tagfunc
  endif

  if &filetype != 'vim'
    nmap <buffer> K <plug>(lsp-hover)
  endif
  nmap <buffer> gK <plug>(lsp-signature-help)

  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)

  if &filetype !=# 'vim'
    nmap <buffer> K <plug>(lsp-hover)
  endif
endfunction

let g:lsp_format_sync_timeout = 1000
let g:lsp_diagnostics_virtual_text_prefix = '●'
let g:lsp_diagnostics_virtual_text_align = 'after'
let g:lsp_diagnostics_virtual_text_padding_left = 4

let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': ''}
let g:lsp_diagnostics_signs_information = {'text': ''}

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

augroup my_lsp
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_settings = {
  \ 'efm-langserver': {
  \   'disabled': v:false
  \ },
  \ '*': {
  \   'config': {
  \     'symbol_kinds': {
  \       '1': ' file',
  \       '2': ' module',
  \       '3': ' namespace',
  \       '4': ' package',
  \       '5': ' class',
  \       '6': ' method',
  \       '7': ' property',
  \       '8': ' field',
  \       '9': ' constructor',
  \       '10': ' enum',
  \       '11': ' interface',
  \       '12': '⨕ function',
  \       '13': ' variable',
  \       '14': ' constant',
  \       '15': 'string',
  \       '16': 'number',
  \       '17': 'boolean',
  \       '18': 'array',
  \       '19': 'object',
  \       '20': 'key',
  \       '21': 'null',
  \       '22': ' enum member',
  \       '23': 'פּ struct',
  \       '24': '鬒 event',
  \       '25': 'Ψ operator',
  \       '26': 'Ψ type parameter'
  \     },
  \     'completion_item_kinds': {
  \       '1': '♣ text',
  \       '2': ' method',
  \       '3': '⨕ function',
  \       '4': ' constructor',
  \       '5': ' field',
  \       '6': ' variable',
  \       '7': ' class',
  \       '8': ' interface',
  \       '9': ' module',
  \       '10': ' property',
  \       '11': ' unit',
  \       '12': ' value',
  \       '13': ' enum',
  \       '14': ' keyword',
  \       '15': ' snippet',
  \       '16': ' color',
  \       '17': ' file',
  \       '18': '渚 reference',
  \       '19': ' folder',
  \       '20': ' enum member',
  \       '21': ' constant',
  \       '22': 'פּ struct',
  \       '23': '鬒 event',
  \       '24': 'Ψ operator',
  \       '25': 'Ψ type parameter'
  \     }
  \   }
  \ }
  \}

"}}}

" Fern: {{{
let g:fern#hide_cursor = 1
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#indent_markers = 1
command! FernCurrentFile Fern . -reveal=%:p
command! FernDrawer Fern . -toggle -drawer -reveal=%

augroup my-glyph-palette
  autocmd! *
    autocmd FileType fern call glyph_palette#apply()
augroup END
" }}}

" QfPreview: {{{
augroup qfpreview
  autocmd!
  autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
augroup END
" }}}

" Gina: {{{
" TODO: 2. gina.vim
" nnoremap <silent> <Leader>aa :<C-u>Gina status<CR>
command! GinaStatus Gina status
" nnoremap <silent> <Leader>aA :<C-u>Gina changes HEAD<CR>
" nnoremap <silent> <Leader>ac :<C-u>Gina commit<CR>
" nnoremap <silent> <Leader>aC :<C-u>Gina commit --amend<CR>
" nnoremap <silent> <Leader>ab :<C-u>Gina branch -av<CR>
command! GinaBranch Gina branch -av
" nnoremap <silent> <Leader>at :<C-u>Gina tag<CR>
" nnoremap <silent> <Leader>ag :<C-u>Gina grep<CR>
" nnoremap <silent> <Leader>aq :<C-u>Gina qrep<CR>
" nnoremap <silent> <Leader>ad :<C-u>Gina changes origin/HEAD...<CR>
" nnoremap <silent> <Leader>ah :<C-u>Gina log --graph<CR>
command! Ginalog Gina log
command! GinaLog Gina log -- %
" nnoremap <silent> <Leader>aH :<C-u>Gina log --graph --all<CR>
" nnoremap <silent> <Leader>al :<C-u>Gina log<CR>
" nnoremap <silent> <Leader>aL :<C-u>Gina log :%<CR>
" nnoremap <silent> <Leader>af :<C-u>Gina ls<CR>
" nnoremap <silent> <Leader>ars :<C-u>Gina show <C-r><C-w><CR>
" nnoremap <silent> <Leader>arc :<C-u>Gina changes <C-r><C-w><CR>
"}}}

" Misc:{{{
" Ref: https://github.com/koron/vim-kaoriya/blob/master/kaoriya/vim/plugins/kaoriya/plugin/cmdex.vim
" :Scratch
"   Open a scratch (no file) buffer.
command! -nargs=0 Scratch new | setlocal bt=nofile noswf | let b:cmdex_scratch = 1
function! s:CheckScratchWritten()
  if &buftype ==# 'nofile' && expand('%').'x' !=# 'x' && exists('b:cmdex_scratch') && b:cmdex_scratch == 1
    setlocal buftype= swapfile
    unlet b:cmdex_scratch
  endif
endfunction
augroup CmdexScratch
  autocmd!
  autocmd BufWritePost * call <SID>CheckScratchWritten()
augroup END

" :Nohlsearch
"   Stronger :nohlsearch
command! -nargs=0 Nohlsearch let @/ = ''
"}}}

" KeyMapping:{{{

map H <Plug>(operator-quickhl-manual-this-motion)

map  <silent>y   <Plug>(operator-flashy)
nmap <silent>Y   <Plug>(operator-flashy)$

inoremap <C-u> <C-g>u<C-u>

" c_CTRL-X
"   Input current buffer's directory on command line.
cnoremap <C-X> <C-R>=<SID>GetBufferDirectory()<CR>
function! s:GetBufferDirectory()
  let path = expand('%:p:h')
  let cwd = getcwd()
  let dir = '.'
  if match(path, escape(cwd, '\')) != 0
    let dir = path
  elseif strlen(path) > strlen(cwd)
    let dir = strpart(path, strlen(cwd) + 1)
  endif
  return dir . (exists('+shellslash') && !&shellslash ? '\' : '/')
endfunction

" alt of vim-operator-replace by kana
" Do NOT rewrite register after paste
" http://baqamore.hatenablog.com/entry/2016/07/07/201856
xnoremap <expr> p printf('pgv"%sygv<esc>', v:register)

if has('win32')
  tnoremap <silent><nowait><C-b> <Left>
  tnoremap <silent><nowait><C-f> <Right>
  tnoremap <silent><nowait><C-e> <End>
  tnoremap <silent><nowait><C-a> <Home>
  tnoremap <silent><nowait><C-u> <Esc>
endif

nnoremap <silent><C-n> <Cmd>cnext \| normal zz<CR>
nnoremap <silent><C-p> <Cmd>cprevious \| normal zz<CR>

nnoremap <silent><C-j> gt
nnoremap <silent><C-k> gT
tnoremap <C-j> <C-w>gt
tnoremap <C-k> <C-w>gT

" Grep with <Leader>gg {{{
function! s:grep(bang, query) abort
  let query = empty(a:query) ? input('grep: ') : a:query
  if empty(query)
    redraw
    return
  endif
  execute printf('silent grep%s %s .', a:bang, escape(query, ' '))
endfunction
" nnoremap <silent> <Leader>gg :<C-u>call <SID>grep('', '')<CR>
command! -nargs=* -bang Grep call s:grep(<q-bang>, <q-args>)
" }}}

"}}}

" END:{{{
syntax enable
filetype plugin indent on

try
  colorscheme iceberg
catch
  colorscheme habamax
endtry

if filereadable(expand('~/.vimrc.local'))
  execute 'source' fnameescape(expand('~/.vimrc.local'))
endif

set secure
" }}}
" vim: tabstop=2 shiftwidth=2 expandtab foldmethod=marker
