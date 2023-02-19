# dotfiles
Essential dotfiles for fun and profit (but mostly fun)

Things should be pretty self-explainatory. Drop files where appropriate. Make sure to read the code before you blindly `source foo.sh`. You never know who might drop an `alias ls="rm -Rf $HOME/*"` on you. Just sayin'...

Topics covered:

- [Easy configuration deployment](#easy-configuration deployment)
- [Colors](#colors-are-bastards)
- [Email](#email)

## Easy configuration deployment

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

## Email

For quite some time I was using [mu4e](https://djcbsoftware.nl/code/mu/mu4e.html) for email but then I got the _immensely_ good idéa that I should go back to using browser based email clients (Office 365, Roundcube and one other company-specific client) for a while, just to get some basis for comparison with my mu4e setup. I rue the day. Truly.

A year was allocated to the experiment wherein I worked on getting proper habits for efficient email handling through the browser. This included workflow improvements, sensible keybindings etc. The conclusion is that it is not possible to do email management efficiently at all when working in the browser. At least not for me. Operations in mu4e are easily done in $1 \over 10$ of the time spent in the browser. For me this is a **substantial** part of my week.

So back to mu4e it is. My current setup includes:

- [isync / mbsync](https://isync.sourceforge.io/) for pulling email for multiple accounts
- [mu](https://djcbsoftware.nl/code/mu/) for indexing email
- [mu4e](https://djcbsoftware.nl/code/mu/mu4e.html) for interacting with email through emacs

As mentioned I pull email for multiple accounts, and likewise I have mu4e set up with multiple contexts. Some people prefer having merged inboxes, but for me having complete isolation between contexts is important for productivity. This is reflected in the setup of keybindings that eg. change folders you jump to depending on the selected context.

The applications mbsync and mu/mu4e are installed through the system package manager (`sudo apt install isync mu4e`). For `mu4e` and `mu` it is done simply because it is very convenient that the emacs package `mu4e` and the system runtime `mu` is in sync in terms of version. For `isync` is also just simpler to get it through the package manager rather than compiling yourself.
