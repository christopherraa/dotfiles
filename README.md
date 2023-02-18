# dotfiles
Essential dotfiles for fun and profit (but mostly fun)

Things should be pretty self-explainatory. Drop files where appropriate. Make sure to read the code before you blindly `source foo.sh`. You never know who might drop an `alias ls="rm -Rf $HOME/*"` on you. Just sayin'...

# Easy configuration deployment

Myself I use [GNU stow](https://www.gnu.org/software/stow/), as that just handles everything with regards to symlinking automatically:

```shell
stow --target=$HOME */
```

## Colors are bastards

Getting colors correct in the terminal is something that keeps popping up as a pain-point. This is especially true when using rich editors such as the two proper ones inside tmux inside a terminal. Available colors should also be 24bit so you actually have a chance of getting a pretty setup. The setup should also not be substantially different if you ssh in and attach tmux VS use the terminal directly through a window manager.

My setup assumes 24bit is set up properly and is based on [this information by Sylvain Benner](https://github.com/syl20bnr/spacemacs/wiki/Terminal). In short:

Put this inside `~/xterm-24bit.terminfo` (_include the last newline!_):
```
xterm-24bit|xterm with 24-bit direct color mode,
   use=xterm-256color,
   sitm=\E[3m,
   ritm=\E[23m,
   setb24=\E[48;2;%p1%{65536}%/%d;%p1%{256}%/%{255}%&%d;%p1%{255}%&%dm,
   setf24=\E[38;2;%p1%{65536}%/%d;%p1%{256}%/%{255}%&%d;%p1%{255}%&%dm,

```

Generate the  `.terminfo` file:
```shell
/usr/bin/tic -x -o ~/.terminfo xterm-24bit.terminfo
```

After that you can enable the new terminfo by adding this to your environment whichever way is appropriate for your setup:
```shell
export TERM=xterm-24bit
```

Tmux also have to be told (~/.tmux.conf`) that 24bit is the bee's knees:
```
set -g default-terminal "xterm-24bit"
set -g terminal-overrides ',xterm-24bit:Tc'
```
