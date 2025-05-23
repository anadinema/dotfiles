ZSH_DISABLE_COMPFIX=true

# This is needed as a lot of stuff depends on it
export DOTFILES="$HOME/dotfiles"

# Import env vars if the file is present
[ -f $DOTFILES/zsh/env ] && source "$DOTFILES"/zsh/env

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
HISTSIZE=5000               		# How many lines of history to keep in memory
SAVEHIST=50000               		# Number of history entries to save to disk
HISTFILE=$DOTFILES/temp/.zsh_history     					# Where to save history to disk

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

### Stuff for brew

eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX="$(brew --prefix)"

# Autocompletion for brew
if type brew &>/dev/null; then
  FPATH=$BREW_PREFIX/share/zsh/site-functions:$BREW_PREFIX/share/zsh-completions:$FPATH
fi

# No analytics data to be sent
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

### Others

# Enable option-stacking for docker (i.e docker run -it <TAB>)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Load private authentication and other environment vars
[ -f $DOTFILES/auth-env ] && source "$DOTFILES"/auth-env

# Add additional aliases and bigger aliases as functions
[ -f $DOTFILES/zsh/aliases ] && source "$DOTFILES"/zsh/aliases
[ -f $DOTFILES/zsh/functions ] && source "$DOTFILES"/zsh/functions

# Path variables updates
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Starship config
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# For sdkman to work
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
