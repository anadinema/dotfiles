ZSH_DISABLE_COMPFIX=true

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to .dotfiles repository
export DOTFILES="$HOME/.dotfiles"

# Disable error when using glob patterns that don't have matches
setopt +o nomatch

# Path to your oh-my-zsh installation.
export ZSH="$HOME/zshell/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchange
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line if you want to change the command execution time
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# History Configuration
HISTSIZE=5000               # How many lines of history to keep in memory
HISTFILE=~/.dotfiles/temp/.zsh_history     # Where to save history to disk
SAVEHIST=5000               # Number of history entries to save to disk
HISTDUP=erase               # Erase duplicates in the history file
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed

# Which plugins would you like to load?
plugins=(
    git
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
    )

### Stuff for brew

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

BREW_PREFIX="$(brew --prefix)"

# Autocompletion for brew
if type brew &>/dev/null; then
  FPATH=$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH
fi

# No analytics data to be sent
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Enable option-stacking for docker (i.e docker run -it <TAB>)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

source $ZSH/oh-my-zsh.sh

# Load powerlevel10k theme and configuration
source $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.dotfiles/source/.p10k.zsh ]] || source ~/.dotfiles/source/.p10k.zsh

# Add additional aliases
source ~/.dotfiles/source/.functions
source ~/.dotfiles/source/.alias

# Add all the path additions to the environment
source ~/.dotfiles/source/.path
