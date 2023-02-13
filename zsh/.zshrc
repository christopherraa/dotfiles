# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme list can be found here: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# I think this one is pretty.
ZSH_THEME="af-magic"

# Use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Make git status through zsh _much_ faster by not marking untracked files as
# part of repo.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Use sensible format for history
HIST_STAMPS="yyyy-mm-dd"

# Set TERM to something giving 24bit colors. You need to generate the correct
# terminfo for this to work properly.
TERM=xterm-24bit

## Unused configuration parameters. Kept here for later reference

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

## /Unused parameters

# Loading plugins. List can be found at https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(git dotenv)
source $ZSH/oh-my-zsh.sh
