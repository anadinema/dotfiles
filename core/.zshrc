# -------------------------------------------------------------
# main env vars and warning suppression
# -------------------------------------------------------------

# Disable compfix warning since we have a lot of custom completions and it can be noisy
ZSH_DISABLE_COMPFIX=true

# This is needed as a lot of stuff depends on it
export DOTFILES="$HOME/dotfiles"

# -------------------------------------------------------------
# setup homebrew + autocompletion for external tool managers
# -------------------------------------------------------------

# Autocomplete directories for custom completions
FPATH=$HOME/.local/share/dotfiles-completions/zsh:$FPATH

# Load the custom completions + mise-en-place completions
[ -f $DOTFILES/zsh/completions.shrc ] && source "$DOTFILES"/zsh/completions.shrc

# Set up Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX="$(brew --prefix)"

# Autocompletion for brew
if type brew &>/dev/null; then
  FPATH=$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH
fi

# Other homebrew options
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# -------------------------------------------------------------
# intialize compinit + zsh and docker completions
# -------------------------------------------------------------

# Added -u to ignore the 'insecure directories' prompt automatically
autoload -Uz compinit && compinit -u
autoload -U +X bashcompinit && bashcompinit -u

# Enable option-stacking for docker (i.e docker run -it <TAB>)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# -------------------------------------------------------------
# import other env vars
# -------------------------------------------------------------

# Import env vars if the file is present
[ -f $DOTFILES/zsh/env.shrc ] && source "$DOTFILES"/zsh/env.shrc

# -------------------------------------------------------------
# setup shell options and history settings
# -------------------------------------------------------------

# Disable error when using glob patterns that don't have matches
setopt +o nomatch

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchange
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line if you want to change the command execution time
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# History Configuration
HISTSIZE=5000                        # How many lines of history to keep in memory
SAVEHIST=50000                       # Number of history entries to save to disk
HISTFILE=$DOTFILES/temp/.zsh_history # Where to save history to disk

setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY         # append to history file
setopt HIST_NO_STORE          # Don't store history commands

# -------------------------------------------------------------
# intialize fzf, zoxide, starship, and other tools
# -------------------------------------------------------------

# Setup fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Setup zoxide - a better cd tool
export _ZO_DATA_DIR="$HOME/.local/share"
eval "$(zoxide init zsh)"

# Setup OpenTofu and autocompletion for it
complete -o nospace -C $(which tofu) tofu
complete -o nospace -C $(which tofu) tf

# Setup aws-cli autocompletion
complete -o nospace -C $(which aws_completer) aws

# Setup starship config
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Setup mise-en-place to manage all other tools
eval "$(mise activate zsh)"

# -------------------------------------------------------------
# load sensitive env vars + shell aliases and functions
# -------------------------------------------------------------

# Load sensitive environment variables related to authentication if the file is present
[ -f $DOTFILES/auth-env.shrc ] && source "$DOTFILES"/auth-env.shrc

# Add additional aliases and bigger aliases as functions
[ -f $DOTFILES/zsh/aliases.shrc ] && source "$DOTFILES"/zsh/aliases.shrc
[ -f $DOTFILES/zsh/functions.shrc ] && source "$DOTFILES"/zsh/functions.shrc
