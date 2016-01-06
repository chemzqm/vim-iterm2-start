# Vim-iterm2-start

Dispatch a task for iTerm2 in MacVim, used for async command line task (eg: git
push and unite tests)

It works much like [vim-dispatch](https://github.com/tpope/vim-dispatch), the
difference is it's works (only) with MacVim, iTerm2 latest and fish shell, in
order to keep it quite simple.  The reason I made this is I found changing the
code of vim-dispatch is quite hard, and it doesn't support iTerm2 > 2.9

Requirement:

* MacVim 7.3+
* iTerm2 > 2.9 currently in beta test (latest lightly build is preferred)
* fish shell (otherwise you will need change the code)
* Knowledge of command line tools

## Update

* notification enabled, looks like:

<img width="355" alt="screen shot 2016-01-07 at 6 17 41 am" src="https://cloud.githubusercontent.com/assets/251450/12157114/603c4ac2-b50a-11e5-82e1-f2054abf3337.png">

## Command

* `ItermStart[!] [options] {command}`

    Start task in current session of iTerm2, when prefix with `!`, not foucs the
    iTerm window

    * -dir=...     run command in given directory
    * -title=...   set label for iTerm2
    * -no-wait     disable the default prompt of `press enter to continue` on
      command error

* `ItermStartTab[!] [options] {command}`

    Start task in a new tab session of iTerm2, options is the same as
    `ItermStart` command

    *NOTE:*  iTerm2 version > Build 2.9.20160103-nightly is required to make
    iTerm2 run job at background corrently

## Global varialbes

* `g:iterm_start_profile` is used for control the profile used by
  `ItermStartTab`, you can crate a profile called `fish` that use fish shell, and 
  config `ItermStartTab` to use fish shell by add:

    let g:iterm_start_profile = 'fish'

  in your `.vimrc`

* `let g:iterm_start_enable=1` would enable Mac notification on command success.
  support `growl` and `terminal-notifier`

## Intergration

If you use [vim-test](https://github.com/janko-m/vim-test), you can make your
test run in background by adding below lines to your `.vimrc`:

    function! StartTest(cmd)
      execute 'ItermStartTab! ' . a:cmd
    endfunction

    let g:test#custom_strategies = {'start': function('StartTest')}
    let g:test#strategy = 'start'

## Send message back to MacVim

You can make use of the vim feature `clientserver` to send message back to your
MacVim, here is a example of creating a filter program that parse output of
mocha and fill the quickfix of MacVim

    https://gist.github.com/chemzqm/fd1313206c182884efbc

So you can jump to error location directly in your MacVim.

## License

MIT
