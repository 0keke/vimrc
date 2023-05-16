" Startup: vim -N -u ~/.vim/min.vim

if &compatible
  set nocompatible
endif

set packpath=

" set runtimepath^=~/dev/github/vim-qf-preview
set runtimepath^=~/dev/github/fern.vim
set runtimepath^=~/dev/github/vim-ambiwidth
set runtimepath^=~/dev/github/fern-renderer-nerdfont.vim
set runtimepath^=~/dev/github/nerdfont.vim
" set runtimepath^=~/dev/github/ddu-ui-ff
" set runtimepath^=~/dev/github/ddu-source-file_rec
" set runtimepath^=~/dev/github/ddu-filter-matcher_substring
" set runtimepath^=~/dev/github/ddu-kind-file
" set runtimepath^=~/dev/github/denops.vim
" set runtimepath^=~/dev/github/ddu.vim

let g:fern#renderer = "nerdfont"
" let g:fern#renderer#nerdfont#indent_markers = 1

" call ddu#custom#patch_global({
"    \   'ui': 'ff',
"    \   'sources': [{'name': 'file_rec', 'params': {}}],
"    \   'sourceOptions': {
"    \     '_': {
"    \       'matchers': ['matcher_substring'],
"    \     },
"    \   },
"    \   'kindOptions': {
"    \     'file': {
"    \       'defaultAction': 'open',
"    \     },
"    \   }
"    \ })
" 
" autocmd FileType ddu-ff call s:ddu_my_settings()
" function! s:ddu_my_settings() abort
"   nnoremap <buffer><silent> <CR>
"        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
"   nnoremap <buffer><silent> <Space>
"        \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
"   nnoremap <buffer><silent> i
"        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
"   nnoremap <buffer><silent> q
"        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
" endfunction
" 
" autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
" function! s:ddu_filter_my_settings() abort
"   inoremap <buffer><silent> <CR>
"  \ <Esc><Cmd>close<CR>
"   nnoremap <buffer><silent> <CR>
"  \ <Cmd>close<CR>
"   nnoremap <buffer><silent> q
"  \ <Cmd>close<CR>
" endfunction

augroup qfpreview
    autocmd!
    autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
augroup END

filetype plugin indent on
syntax on

colorscheme habamax
