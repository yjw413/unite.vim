"=============================================================================
" FILE: file.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 01 Apr 2011.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! unite#kinds#file#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'file',
      \ 'default_action' : 'open',
      \ 'action_table' : {},
      \ 'parents' : ['openable', 'cdable'],
      \}

" Actions"{{{
let s:kind.action_table.open = {
      \ 'description' : 'open files',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.open.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('edit', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'description' : 'preview file or buffer',
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate)"{{{
  if filereadable(a:candidate.action__path)
    call s:execute_command('pedit', l:candidate)
  endif
endfunction"}}}

let s:kind.action_table.tabopen = {
      \ 'description' : 'tabopen files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.tabopen.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('tabedit', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.split = {
      \ 'description' : 'horizontal split open files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.split.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('split', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.vsplit = {
      \ 'description' : 'vertical split open files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.vsplit.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('vsplit', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.left = {
      \ 'description' : 'vertical left split files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.left.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('leftabove vsplit', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.right = {
      \ 'description' : 'vertical right split open files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.right.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('rightbelow vsplit', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.above = {
      \ 'description' : 'horizontal above split open files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.above.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('leftabove split', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.below = {
      \ 'description' : 'horizontal below split open files or buffers',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.below.func(candidates)"{{{
  for l:candidate in a:candidates
    call s:execute_command('rightbelow split', l:candidate)
  endfor
endfunction"}}}

let s:kind.action_table.mkdir = {
      \ 'description' : 'make this directory or parents directory',
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ }
function! s:kind.action_table.mkdir.func(candidate)"{{{
  if !filereadable(a:candidate.action__path)
    call mkdir(iconv(a:candidate.action__path, &encoding, &termencoding), 'p')
  endif
endfunction"}}}

"}}}

function! s:execute_command(command, candidate)"{{{
  let l:dir = unite#util#path2directory(a:candidate.action__path)
  " Auto make directory.
  if !isdirectory(l:dir) &&
        \ input(printf('"%s" does not exist. Create? [y/N]', l:dir)) =~? '^y\%[es]$'
    call mkdir(iconv(l:dir, &encoding, &termencoding), 'p')
  endif

  silent call unite#util#smart_execute_command(a:command, a:candidate.action__path)
endfunction"}}}

" vim: foldmethod=marker
