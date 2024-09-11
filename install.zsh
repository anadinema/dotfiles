#!/bin/zsh

setopt +o nomatch

LINE=----------------------------------------------------------------
DOTFILES=$DOTFILES || $HOME/.dotfiles
DEFAULTS=false

install_homebrew() {
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

brew_apps() {
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

setup_dotfiles() {
  echo ""$LINE"\n ### Removing existing folder/symlinks if present on user home... ### \n"$LINE""
  for file in $(find $(pwd) -type f | grep stow | grep -v .config | grep -v .ssh | grep -v .m2 | sed 's/\/.dotfiles\/stow//g')
  do
    echo "$file"
    rm -rf "$file" || true
  done
  for folder in $(find $(pwd) -type d | grep stow | grep -v .config | sed 's/\/.dotfiles\/stow//g')
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

perform_cleanup() {
  echo " ### Cleaning up... ### \n"$LINE""
  (rm -rf $HOME/.lesshst || true) && (rm -rf $HOME/.zcompdump* || true) && (rm -rf $HOME/.zsh_history* || true) && ( rm -rf $HOME/.zshrc.pre* || true) && ( rm -rf $HOME/.zprofile || true)
  mkdir -p $DOTFILES/temp
  rm -rf $DOTFILES/fonts
  echo " ### All set and good to move ahead... ### \n"$LINE""
}

install_fonts() {
  if [ $(find ~/Library/Fonts -name JetBrainsMono*.ttf | wc -l) -le 5 ]; then
    echo ""$LINE"\n ### Installing fonts... ### \n"$LINE""
    if [ -d "$DOTFILES"/fonts/jetbrains ]; then
      rm -rf $DOTFILES/fonts/jetbrains
    fi
		git clone --filter=blob:none --depth=1 --sparse https://github.com/ryanoasis/nerd-fonts "$DOTFILES"/fonts/jetbrains
		git -C "$DOTFILES"/fonts/jetbrains sparse-checkout add patched-fonts/JetBrainsMono
    "$DOTFILES"/fonts/jetbrains/install.sh JetBrainsMono
    echo ""$LINE"\n ### Fonts installed and placed in the Fontbook... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Fonts are already installed... skipping the step... ### \n"$LINE""
  fi
}

set_java_version() {
  echo ""$LINE"\n ### Setting java version to 21... ### \n"$LINE""
  jvm 21
}

set_node_version() {
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

set_macos_defaults() {
  if [ $DEFAULTS == true ]; then
    echo ""$LINE"\n ### Running defaults to restore settings for macos... ### \n"$LINE""
    zsh scripts/defaults.zsh
    echo ""$LINE"\n ### Initialization of defaults completed... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Env not set for running defaults... skipping the defaults step... ### \n"$LINE""
  fi
}

setup() {
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

main() {
  setup
  install_fonts
  install_homebrew
  brew_apps
  setup_dotfiles
  set_java_version
  set_node_version
  set_macos_defaults
  perform_cleanup
}

main
