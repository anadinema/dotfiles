#!/bin/zsh

setopt +o nomatch

LINE=----------------------------------------------------------------
DOTFILES=$DOTFILES || $HOME/.dotfiles
DEFAULTS=true

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

install_ohmyzsh() {
  if [ ! -d "$HOME"/zshell/.oh-my-zsh ]; then
    echo ""$LINE"\n ### Installing oh-my-zsh... ### \n"$LINE""
    ZSH=$HOME/zshell/.oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc --unattended
  else
    echo ""$LINE"\n ### oh-my-zsh is already installed... skipping installation... ###\n"$LINE""
  fi
  echo ""$LINE"\n ### Installing plugins... ### \n"$LINE""
  if [ ! -d "$ZSH"/custom/plugins/zsh-autosuggestions ];then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions || exit 1
  elif [ ! -d "$ZSH"/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting || exit 1
  else
    echo ""$LINE"\n ### oh-my-zsh and related plugins already installed... ### \n"$LINE""
  fi
  echo ""$LINE"\n ### oh-my-zsh and related plugins installed... ### \n"$LINE""
}

install_p10k() {
  if [ ! -d "$HOME"/zshell/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    echo ""$LINE"\n ### Installing powerlevel10k... ### \n"$LINE""
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/zshell/.oh-my-zsh/custom/themes/powerlevel10k
    echo ""$LINE"\n ### powerlevel10k installed... ### \n"$LINE""
  else
    echo ""$LINE"\n ### powerlevel10k is already installed... skipping installation... ### \n"$LINE""
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
  reload
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

setup_docker_plugins() {
  echo ""$LINE"\n ### Setting up docker plugins... ### \n"$LINE""
  if [ ! -d "$HOME"/.docker/cli-plugins ]; then
    mkdir -p ~/.docker/cli-plugins
  fi
  if [ ! -d "$HOME"/.docker/cli-plugins/docker-compose ]; then
    ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
  fi
  if [ ! -d "$HOME"/.docker/cli-plugins/docker-buildx ]; then
    ln -sfn /opt/homebrew/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
  fi
  echo ""$LINE"\n ### docker plugins linked to symlink... ### \n"$LINE""
}

install_fonts() {
  if [ $(find ~/Library/Fonts -name JetBrainsMono*.ttf | wc -l) -le 5 ]; then
    echo ""$LINE"\n ### Installing fonts... ### \n"$LINE""
    if [ -d "$DOTFILES"/fonts/jetbrains ]; then
      rm -rf $DOTFILES/fonts/jetbrains
    fi
    git clone --depth=1 https://github.com/JetBrains/JetBrainsMono "$DOTFILES"/fonts/jetbrains
    cp -f $DOTFILES/fonts/jetbrains/fonts/ttf/*.ttf ~/Library/Fonts/
    echo ""$LINE"\n ### Fonts installed and placed in the Fontbook... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Fonts are already installed... skipping the step... ### \n"$LINE""
  fi
}

set_java_version() {
  echo ""$LINE"\n ### Setting java version to 21... ### \n"$LINE""
  jvmuse 21
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
  install_ohmyzsh
  install_p10k
  setup_docker_plugins
  setup_dotfiles
  set_java_version
  set_node_version
  set_macos_defaults
  perform_cleanup
}

main