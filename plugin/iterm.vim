" ============================================================================
" Description: Start a task in iTerm2
" Author: Qiming Zhao <chemzqm@gmail.com>
" Licence: Vim licence
" Version: 0.1
" Last Modified:  December 30, 2015
" ============================================================================
if exists('g:did_vim_iterm2_start_loaded') || !has('gui_macvim') || v:version < 700
  finish
endif

let g:did_vim_iterm2_start_loaded = 1

function! s:ItermStart(bang, tab, ...)
  let opts = s:ParseArgs(a:000)
  let opts.active = len(a:bang) ? 0 : 1
  let opts.newtab = a:tab
  let opts.profile = get(g:, 'iterm_start_profile', 'default')
  let command = opts.command
  call remove(opts, 'command')
  call Iterm#Start(command, opts)
endfunction

function! s:ParseArgs(args)
  let cmds = []
  let res = {'wait': 1}
  for str in a:args
    if str =~# '^-dir='
      let res.dir = split(str, '=')[1]
    elseif str =~# '^-title='
      let res.title = split(str, '=')[1]
    elseif str =~# '^-no-wait'
      let res.wait = 0
    else
      call add(cmds, str)
    endif
  endfor
  let res.command = join(cmds, ' ')
  return res
endfunction

command! -bang -nargs=+ ItermStart    :call s:ItermStart('<bang>', 0, <f-args>)
command! -bang -nargs=+ ItermStartTab :call s:ItermStart('<bang>', 1, <f-args>)
