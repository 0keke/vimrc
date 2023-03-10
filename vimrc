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
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f\ %l%m
endif

" Grep with <Leader>gg {{{
function! s:grep(bang, query) abort
  let query = empty(a:query) ? input('grep: ') : a:query
  if empty(query)
    redraw
    return
  endif
  execute printf('silent grep%s %s .', a:bang, escape(query, ' '))
endfunction
nnoremap <silent> <Leader>gg :<C-u>call <SID>grep('', '')<CR>
command! -nargs=* -bang Grep call s:grep(<q-bang>, <q-args>)

" }}}

"}}}

" Plugins:{{{

function! PackInit() abort
  call s:ensure_minpac()

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Additional plugins here.
  call minpac#add('vim-jp/syntax-vim-ex')
  call minpac#add('tyru/open-browser.vim')

  " https://twitter.com/mattn_jp/status/1526718582264320000
  " call minpac#add('rbtnn/vim-ambiwidth')

  call minpac#add('tyru/caw.vim')
  call minpac#add('machakann/vim-sandwich')

  call minpac#add('kana/vim-operator-user')

  call minpac#add('kana/vim-textobj-entire')
  call minpac#add('kana/vim-textobj-user')

  call minpac#add('lambdalisue/fern.vim')
  call minpac#add('lambdalisue/nerdfont.vim')
  call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
  call minpac#add('lambdalisue/glyph-palette.vim')
  call minpac#add('lambdalisue/fern-hijack.vim')

  call minpac#add('mattn/vim-lsp-settings')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('tsuyoshicho/vim-efm-langserver-settings')

  call minpac#add('t9md/vim-quickhl')
  call minpac#add('lambdalisue/gina.vim')
  call minpac#add('previm/previm')

  " color scheme
  call minpac#add('NLKNguyen/papercolor-theme')
  call minpac#add('cocopon/iceberg.vim')
  call minpac#add('sainnhe/edge')
  call minpac#add('EdenEast/nightfox.nvim')

  " copmpletion
  call minpac#add('prabirshrestha/asyncomplete.vim', {'type': 'opt'})
  call minpac#add('prabirshrestha/asyncomplete-lsp.vim', {'type': 'opt'})

  " ddu
  call minpac#add('Milly/ddu-filter-kensaku')
  " call minpac#add('Shougo/ddu-column-filename')
  call minpac#add('Shougo/ddu-commands.vim')
  call minpac#add('Shougo/ddu-filter-matcher_substring')
  " call minpac#add('Shougo/ddu-filter-sorter_alpha')
  call minpac#add('Shougo/ddu-kind-file')
  " call minpac#add('Shougo/ddu-kind-word')
  call minpac#add('Shougo/ddu-source-action')
  " call minpac#add('Shougo/ddu-source-file')
  call minpac#add('Shougo/ddu-source-file_rec')
  call minpac#add('Shougo/ddu-source-line')
  " call minpac#add('Shougo/ddu-source-register')
  call minpac#add('Shougo/ddu-ui-ff')
  call minpac#add('Shougo/ddu.vim')
  call minpac#add('kuuote/ddu-source-mr')
  " call minpac#add('matsui54/ddu-source-command_history')
  " call minpac#add('matsui54/ddu-vim-ui-select')
  " call minpac#add('mikanIchinose/ddu-source-markdown')
  call minpac#add('matsui54/ddu-source-file_external')
  call minpac#add('shun/ddu-source-rg')

  " Denops
  " call minpac#add('lambdalisue/askpass.vim')
  call minpac#add('lambdalisue/gin.vim')
  " call minpac#add('lambdalisue/guise.vim')
  call minpac#add('lambdalisue/kensaku.vim')
  " call minpac#add('skanehira/denops-translate.vim')
  " call minpac#add('vim-denops/denops-shared-server.vim')
  call minpac#add('vim-denops/denops.vim')
  call minpac#add('yuki-yano/fuzzy-motion.vim')
  call minpac#add('lambdalisue/mr.vim')

  call minpac#add('ctrlpvim/ctrlp.vim')
  call minpac#add('ompugao/ctrlp-kensaku')
  call minpac#add('halkn/ctrlp-ripgrep')

  call minpac#add('https://github.com/lambdalisue/fin.vim')
  call minpac#add('https://github.com/bfrg/vim-qf-preview')

  call minpac#add('tyru/restart.vim')
  call minpac#add('mattn/vim-sonictemplate')
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


  nmap <buffer> <leader>cd <plug>(lsp-document-diagnostics)
  nmap <buffer> <leader>cl <Cmd>LspInfo<CR>
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gD <plug>(lsp-peek-declaration)
  nmap <buffer> gI <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  if &filetype != 'vim'
    nmap <buffer> K <plug>(lsp-hover)
  endif
  nmap <buffer> gK <plug>(lsp-signature-help)

  nmap <buffer> <leader>cr <plug>(lsp-rename)
  nmap <buffer> <leader>cf <plug>(lsp-document-format)
  nmap <buffer> [d <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d <plug>(lsp-next-diagnostic)

  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  if &filetype !=# 'vim'
    nmap <buffer> K <plug>(lsp-hover)
  endif
endfunction

let g:lsp_format_sync_timeout = 1000
let g:lsp_diagnostics_virtual_text_prefix = '???'
let g:lsp_diagnostics_virtual_text_align = 'after'
let g:lsp_diagnostics_virtual_text_padding_left = 4

let g:lsp_diagnostics_signs_error = {'text': '???'}
let g:lsp_diagnostics_signs_warning = {'text': '???'}
let g:lsp_diagnostics_signs_hint = {'text': '???'}
let g:lsp_diagnostics_signs_information = {'text': '???'}

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
  \       '1': '??? file',
  \       '2': '??? module',
  \       '3': '??? namespace',
  \       '4': '??? package',
  \       '5': '??? class',
  \       '6': '??? method',
  \       '7': '??? property',
  \       '8': '??? field',
  \       '9': '??? constructor',
  \       '10': '??? enum',
  \       '11': '??? interface',
  \       '12': '??? function',
  \       '13': '??? variable',
  \       '14': '??? constant',
  \       '15': 'string',
  \       '16': 'number',
  \       '17': 'boolean',
  \       '18': 'array',
  \       '19': 'object',
  \       '20': 'key',
  \       '21': 'null',
  \       '22': '??? enum member',
  \       '23': '??? struct',
  \       '24': '??? event',
  \       '25': '?? operator',
  \       '26': '?? type parameter'
  \     },
  \     'completion_item_kinds': {
  \       '1': '??? text',
  \       '2': '??? method',
  \       '3': '??? function',
  \       '4': '??? constructor',
  \       '5': '??? field',
  \       '6': '??? variable',
  \       '7': '??? class',
  \       '8': '??? interface',
  \       '9': '??? module',
  \       '10': '??? property',
  \       '11': '??? unit',
  \       '12': '??? value',
  \       '13': '??? enum',
  \       '14': '??? keyword',
  \       '15': '??? snippet',
  \       '16': '??? color',
  \       '17': '??? file',
  \       '18': '??? reference',
  \       '19': '??? folder',
  \       '20': '??? enum member',
  \       '21': '??? constant',
  \       '22': '??? struct',
  \       '23': '??? event',
  \       '24': '?? operator',
  \       '25': '?? type parameter'
  \     }
  \   }
  \ }
  \}

"}}}

" Fern: {{{
let g:fern#hide_cursor = 1
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#indent_markers = 1
nnoremap <Leader>ee <Cmd>Fern . -reveal=%:p<CR>
nnoremap <Leader>EE <Cmd>Fern . -toggle -drawer -reveal=%<CR>

augroup my-glyph-palette
  autocmd! *
    autocmd FileType fern call glyph_palette#apply()
augroup END
" }}}

" DDU: {{{
call ddu#custom#patch_global(#{
  \   ui: 'ff',
  \   sources: [{'name': 'file_rec', 'params': {}}],
  \   sourceOptions: #{
  \     _: {
  \       'matchers': ['matcher_substring'],
  \     },
  \     line: {
  \       'matchers': ['matcher_kensaku'],
  \     },
  \     file_external: #{
  \       matchers: ['matcher_substring'],
  \     },
  \   },
  \   kindOptions: #{
  \     action: #{
  \       defaultAction: 'do',
  \     },
  \     file: #{
  \       defaultAction: 'open',
  \     },
  \   },
  \   filterParams: #{
  \     matcher_substring: #{
  \       highlightMatched: 'Search',
  \     },
  \     matcher_kensaku: #{
  \       highlightMatched: 'Search',
  \     },
  \   },
  \   sourceParams: #{
  \     file_external: #{
  \       cmd: ['rg', '--files', '--glob', '!.git',
  \               '--color', 'never', '--no-messages'],
  \           updateItems: 50000,
  \     },
  \   },
  \ })

nnoremap <silent> <Leader>ff <Cmd>call ddu#start(#{
  \   name: 'file-rec',
  \   sources: [#{
  \     name: 'file_rec',
  \   }],
  \   uiParams: #{
  \     ff: #{
  \       startFilter: v:true
  \     },
  \   },
  \ })<CR>

nnoremap <Leader>dl <Cmd>call ddu#start(#{
  \   name: 'Line',
  \   sources: [#{
  \     name: 'line',
  \   }],
  \   uiParams: #{
  \     ff: #{
  \       startFilter: v:true
  \     },
  \   },
  \ })<CR>

nnoremap <silent> <Leader>dg <Cmd>call ddu#start(#{
  \   name: 'search',
  \   sources: [#{
  \     name: 'rg',
  \     params: #{
  \       input: input('grep: '),
  \     },
  \   }],
  \   uiParams: #{
  \     ff: #{
  \       ignoreEmpty: v:true,
  \     },
  \   },
  \ })<CR>

nnoremap <silent> <Leader>d, <Cmd>call ddu#start(#{
  \   name: 'mrw',
  \   sources: [#{
  \     name: 'mr',
  \     params: #{
  \       kind: 'mrw',
  \     },
  \   }],
  \   uiParams: #{
  \     ff: #{
  \       startFilter: v:true
  \     },
  \   },
  \   uiOptions: #{
  \     ff: #{
  \       defaultAction: 'cd',
  \     },
  \   },
  \ })<CR>

nnoremap <silent> <Leader>dmr <Cmd>call ddu#start(#{
  \   name: 'mrr',
  \   sources: [#{
  \     name: 'mr',
  \     params: #{
  \       kind: 'mrr',
  \     },
  \   }],
  \   uiOptions: #{
  \     ff: #{
  \       defaultAction: 'cd',
  \     },
  \   },
  \ })<CR>

nnoremap <silent> <Leader>dd <Cmd>call ddu#start(#{
  \   name: 'dotfiles',
  \   sources: [#{
  \     name: 'file_rec',
  \     params: #{
  \       ignoredDirectories: [
  \         '.git',
  \         'pack',
  \       ],
  \     },
  \     options: #{
  \       path: expand('~/.vim')
  \     },
  \   }],
  \   uiParams: #{
  \     ff: #{
  \       startFilter: v:true
  \     },
  \   },
  \ })<CR>

function! s:ddu_execute(expr) abort
  if !exists('g:ddu#ui#ff#_filter_parent_winid')
    return
  endif
  call win_execute(g:ddu#ui#ff#_filter_parent_winid, a:expr)
endfunction

function! s:my_ddu_ff_filter()
  inoremap <buffer> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  " use <Esc> to exit from insert mode.
  inoremap <buffer> <Esc> <Esc><Cmd>call ddu#ui#ff#close()<CR>
  nnoremap <buffer> <Esc> <Cmd>call ddu#ui#ff#close()<CR>
  nnoremap <buffer> q <Cmd>close<CR>

  inoremap <buffer> <C-g> <Cmd>call <SID>ddu_execute('normal! j')<CR>
  inoremap <buffer> <C-n> <Cmd>call <SID>ddu_execute('normal! j')<CR>
  inoremap <buffer> <C-t> <Cmd>call <SID>ddu_execute('normal! k')<CR>
  inoremap <buffer> <C-p> <Cmd>call <SID>ddu_execute('normal! k')<CR>
  inoremap <buffer> <C-u> <Cmd>call <SID>ddu_execute('normal! \<C-u>')<CR>
  inoremap <buffer> <C-d> <Cmd>call <SID>ddu_execute('normal! \<C-d>')<CR>
endfunction

function! s:my_ddu_ff()
  setlocal cursorline
  nnoremap <buffer> a <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
  nnoremap <buffer> <CR> <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer> i    <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer> <Esc> <Cmd>call ddu#ui#ff#do_action('quit')<CR>
  nnoremap <buffer> q    <Cmd>call ddu#ui#ff#do_action('quit')<CR>
  nnoremap <buffer> p <Cmd>call ddu#ui#ff#do_action('preview')<CR>
endfunction

augroup my-ddu
  autocmd!
  autocmd FileType ddu-ff call s:my_ddu_ff()
  autocmd FileType ddu-ff-filter call s:my_ddu_ff_filter()
augroup END

" }}}

" FuzzyMotion: {{{
nnoremap <Leader><Leader> <Cmd>FuzzyMotion<CR>

" Enable kensaku.vim matcher
let g:fuzzy_motion_matchers = ['fzf', 'kensaku']

" Disable word split feature
let g:fuzzy_motion_word_filter_regexp_list = []
" }}}

" CtrlP {{{
let g:ctrlp_match_func = {'match': 'ctrlp_kensaku#matcher'}
nnoremap <Space>pf <Cmd>CtrlP<CR>
nnoremap <Space>pl <Cmd>CtrlPLine<CR>
nnoremap <Space>pg <Cmd>CtrlPRg<CR>
" }}}

" Gina: {{{
" TODO: 2. gina.vim
nnoremap <silent> <Leader>aa :<C-u>Gina status<CR>
" nnoremap <silent> <Leader>aa :<C-u>GinaPreview<CR>
nnoremap <silent> <Leader>aA :<C-u>Gina changes HEAD<CR>
nnoremap <silent> <Leader>ac :<C-u>Gina commit<CR>
nnoremap <silent> <Leader>aC :<C-u>Gina commit --amend<CR>
nnoremap <silent> <Leader>ab :<C-u>Gina branch -av<CR>
nnoremap <silent> <Leader>at :<C-u>Gina tag<CR>
nnoremap <silent> <Leader>ag :<C-u>Gina grep<CR>
nnoremap <silent> <Leader>aq :<C-u>Gina qrep<CR>
nnoremap <silent> <Leader>ad :<C-u>Gina changes origin/HEAD...<CR>
nnoremap <silent> <Leader>ah :<C-u>Gina log --graph<CR>
nnoremap <silent> <Leader>aH :<C-u>Gina log --graph --all<CR>
nnoremap <silent> <Leader>al :<C-u>Gina log<CR>
nnoremap <silent> <Leader>aL :<C-u>Gina log :%<CR>
nnoremap <silent> <Leader>af :<C-u>Gina ls<CR>
nnoremap <silent> <Leader>ars :<C-u>Gina show <C-r><C-w><CR>
nnoremap <silent> <Leader>arc :<C-u>Gina changes <C-r><C-w><CR>
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
"}}}

" END:{{{
syntax enable
filetype plugin indent on

try
  colorscheme iceberg
catch
  colorscheme habamax
endtry

hi link LspInformationHighlight DiagnosticUnderlineInfo
hi link LspHintHighlight DiagnosticUnderlineHint
hi link LspWarningHighlight  DiagnosticUnderlineWarn
hi link LspErrorHighlight  DiagnosticUnderlineError

hi link LspErrorVirtualText DiagnosticError
hi link LspWarningVirtualText DiagnosticWarn
hi link LspInformationVirtualText DiagnosticInfo
hi link LspHintVirtualText  DiagnosticHint

hi link LspErrorText DiagnosticSignError
hi link LspWarningText DiagnosticSignWarn
hi link LspInformationText DiagnosticSignInfo
hi link LspHintText DiagnosticSignHint

if filereadable(expand('~/.vimrc.local'))
  execute 'source' fnameescape(expand('~/.vimrc.local'))
endif

set secure
" }}}
" vim: tabstop=2 shiftwidth=2 expandtab foldmethod=marker
