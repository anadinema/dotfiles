#!/bin/zsh

setopt +o nomatch

LINE=----------------------------------------------------------------
DOTFILES=$DOTFILES || $HOME/dotfiles
DEFAULTS=false

# Install homebrew to further install all other stuff
__install_homebrew() {
  if type brew &>/dev/null; then
    echo ""$LINE"\n ### homebrew is already installed... skipping installation... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Installing homebrew... ### \n"$LINE""
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    source ~/.zprofile
    brew doctor
    echo ""$LINE"\n ### homebrew installed... ### \n"$LINE""
  fi
}

# Install all the cli tools, apps, fonts using homebrew
__brew_apps() {
  if ! brew list | grep bat &>/dev/null; then
    echo ""$LINE"\n ### Installing brew bundle... ### \n"$LINE""
    brew bundle install --file brew/Brewfile
    echo ""$LINE"\n ### brew bundle installed... ### \n"$LINE""
    brew list
    echo "$LINE"
  else
    echo ""$LINE"\n ### brew bundle is already installed... running upgrade and cleanup instead... ### \n"$LINE""
    brew upgrade && brew cleanup
    echo "$LINE"
  fi
}

# Remove the original files, if present and then setup the symlinks
__setup_dotfiles() {
  echo ""$LINE"\n ### Removing existing folder/symlinks if present on user home... ### \n"$LINE""
  for file in $(find $(pwd) -type f | grep stow | grep -v .config | grep -v .ssh | grep -v .m2 | sed 's/\/dotfiles\/stow//g')
  do
    echo "$file"
    rm -rf "$file" || true
  done
  for folder in $(find $(pwd) -type d | grep stow | grep -v .config | sed 's/\/dotfiles\/stow//g')
  do
    if [[ ! $folder == $HOME ]]; then
      echo "$folder"
      rm -rf "$folder" || true
    fi
  done
  rm -rf $HOME/.config || true
  rm -rf "$HOME/.zshrc.pre*"
  echo ""$LINE"\n ### Folders/symlinks removed... Stowing now... ### \n"$LINE""
  stow stow
  cd "$HOME"
  sleep 4
  source ~/.zshrc
  if ! echo "$DOTFILES" &>/dev/null; then
    echo "### Either syslink or reload failed... Exiting now.. ### \n"$LINE"" && exit 1
  else
    echo " ### Stowing completed... ### \n"$LINE"" && cd "$DOTFILES"
  fi
}

# Perform the cleanup with the unnecessary files
__perform_cleanup() {
  echo " ### Cleaning up... ### \n"$LINE""
  (rm -rf $HOME/.lesshst || true) && (rm -rf $HOME/.zcompdump* || true) && (rm -rf $HOME/.zsh_history* || true) && ( rm -rf $HOME/.zshrc.pre* || true) && ( rm -rf $HOME/.zprofile || true)
  mkdir -p $DOTFILES/temp
  echo " ### All set and good to move ahead... ### \n"$LINE""
}

# Set the java version to 21
__set_java_version() {
  echo ""$LINE"\n ### Setting java version to 21... ### \n"$LINE""
  jvm 21
}

# Install the LTS node version using nvm and set it as default
__set_node_version() {
  echo ""$LINE"\n ### Installing node LTS version through nvm... ### \n"$LINE""
  if [ $(nvm list node | grep v | wc -l) -le 0 ]; then
    nvm install --lts
    nvm use --lts
    echo ""$LINE"\n ### Node LTS version installed through nvm... ### \n"$LINE""
    node --version
  else
    nvm use default
    echo ""$LINE"\n ### Node is already installed... skipping the step... ### \n"$LINE""
    node --version
  fi
}

# Set the macos defaults using scripts/default.zsh
__set_macos_defaults() {
  if [ $DEFAULTS == true ]; then
    echo ""$LINE"\n ### Running defaults to restore settings for macos... ### \n"$LINE""
    zsh scripts/defaults.zsh
    echo ""$LINE"\n ### Initialization of defaults completed... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Env not set for running defaults... skipping the defaults step... ### \n"$LINE""
  fi
}

# Setup function to make sure the sudo doesn't timeout
__setup() {
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

# Main function definition and order in which other functions will be executed
main() {
  __setup
  __install_homebrew
  __brew_apps
  __setup_dotfiles
  __set_java_version
  __set_node_version
  __set_macos_defaults
  __perform_cleanup
}

# Execute the main functions
main
