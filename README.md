# dotfiles
Essential dotfiles for fun and profit (but mostly fun)

Things should be pretty self-explainatory. Drop files where appropriate. Make sure to read the code before you blindly `source foo.sh`. You never know who might drop an `alias ls="rm -Rf $HOME/*"` on you. Just sayin'...

Myself I use [GNU stow](https://www.gnu.org/software/stow/), as that just handles everything with regards to symlinking automatically:

```shell
stow --target=$HOME */
```
