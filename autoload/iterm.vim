if exists('g:autoloaded_vim_iterm2_start')
  finish
endif
let g:autoloaded_vim_iterm2_start = 1

function! Iterm#Start(command, opts)
  let script = s:isolate(a:command, a:opts)
  let title = get(a:opts, 'title', 'vim-iterm2-start')
  let profile = get(a:opts, 'profile', 'default')
  if a:opts.profile ==# 'default'
    let profile = 'default profile'
  else
    let profile = 'profile "' . a:opts.profile . '"'
  endif
  let dir = get(a:opts, 'dir', getcwd())
  let newtab = a:opts.newtab
  return s:osascript(
      \ 'if application "iTerm" is not running',
      \   'error',
      \ 'end if') && s:osascript(
      \ 'tell application "iTerm"',
      \   'tell current window',
      \     newtab ? 'create tab with ' . profile : '',
      \     newtab ? 'tell application "MacVim"' : '',
      \     newtab ? 'activate' : '',
      \     newtab ? 'end tell' : '',
      \     'tell current session',
      \       'set title to "' . title . '"',
      \       'set name to "' . title . '"',
      \       'write text ""',
      \       'write text "clear"',
      \       'write text ' . s:escape('fish ' . script. ' %self'),
      \       'end tell',
      \       a:opts.active ? 'activate' : '',
      \     'end tell',
      \ 'end tell')
endfunction

" wrap command with fish script and write to a temp file
function! s:isolate(command, opts)
  let onend = a:opts.newtab ? '  kill $argv[1]' : ''
  let dir = get(a:opts, 'dir', getcwd())
  let lines = [
        \ 'cd ' . fnameescape(dir),
        \ 'echo "' . a:command . '"',
        \ a:command,
        \ 'set res $status',
        \ 'if test $res -eq 0',
        \ onend,
        \ '  exit',
        \ 'end',
        \]
  if get(a:opts, 'wait', 0)
    let lines = lines + [
      \ 'echo ''<----- press any key to continue ----->''',
      \ 'read -p ''''  -n 1 foo',
      \]
  else
    call add(lines, 'exit $res')
  endif
  let lines = lines + [onend]
  let temp = tempname()
  call writefile(lines, temp)
  return temp
endfunction

function! s:osascript(...) abort
  let args = join(map(copy(a:000), '" -e ".shellescape(v:val)'), '')
  call system('osascript'. args)
  return !v:shell_error
endfunction

function! s:escape(string) abort
  return '"'.escape(a:string, '"\').'"'
endfunction
