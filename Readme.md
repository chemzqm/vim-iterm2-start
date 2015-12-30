# Vim-iterm2-start

Dispatch a task for iTerm2 in MacVim, used for async command line task.

Prerequirement:

* MacVim 7.3+
* iTerm2 > 2.9 currently in beta test
* fish shell (otherwise you will need change the code)
* Knowledge of command line tools

## Command

* `[!]ItermStart [options] {command}`

    Start task in current session of iTerm2, when prefix with `!`, not foucs the iTerm window

    * -dir=...     run command in given directory
    * -title=...   set lable for iTerm2
    * -no-wait      disable the default prompt of `press enter to continue` on command error

* `[!]ItermStartTab [options] {command}`

    Start task in a new tab session of iTerm2, options is the same as `ItermStart` command
