if exists('g:autoloaded_vim_iterm2_start')
  finish
endif
let g:autoloaded_vim_iterm2_start = 1
let s:success_image = expand('<sfile>:h:h').'/success.png'

function! Iterm#Start(command, opts)
  let script = s:isolate(a:command, a:opts)
  let title = get(a:opts, 'title', 'vim-iterm2-start')
  let profile = get(a:opts, 'profile', 'default')
  if get(a:opts, 'profile', 'default') ==# 'default'
    let profile = 'default profile'
  else
    let profile = 'profile "' . a:opts.profile . '"'
  endif
  let dir = get(a:opts, 'dir', getcwd())
  let newtab = a:opts.newtab
  return s:osascript(
      \ 'if application "iTerm2" is not running',
      \   'error',
      \ 'end if') && s:osascript(
      \ 'tell application "iTerm2"',
      \   'tell current window',
      \     newtab ? 'create tab with ' . profile : '',
      \     'tell current session',
      \       'set title to "' . title . '"',
      \       'set name to "' . title . '"',
      \       'write text ""',
      \       'write text "clear"',
      \       'write text ' . s:escape('fish ' . script. ' %self'),
      \       a:opts.active ? 'activate' : '',
      \     'end tell',
      \   'end tell',
      \ 'end tell')
endfunction

" wrap command with fish script and write to a temp file
function! s:isolate(command, opts)
  let onend = a:opts.newtab ? '  kill $argv[1]' : ''
  let dir = get(a:opts, 'dir', getcwd())
  if executable('growlnotify') && get(g:, 'iterm_start_growl_enable', 0)
    if executable('terminal-notifier')
      let growl = 'terminal-notifier -sender org.vim.MacVim -title ''done'''
          \.'  -message '''.a:command.''''
    else
      let growl = ' growlnotify -m ""'
    endif
  end
  let lines = [
        \ 'cd ' . fnameescape(dir),
        \ 'echo "' . a:command . '"',
        \ a:command,
        \ 'set res $status',
        \ 'if test $res -eq 0',
        \ exists('growl') ? growl : '',
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
  let output =  system('osascript'. args)
  if v:shell_error && output !=# ""
    echohl Error | echon output | echohl None
  endif
  return !v:shell_error
endfunction

function! s:escape(string) abort
  return '"'.escape(a:string, '"\').'"'
endfunction
