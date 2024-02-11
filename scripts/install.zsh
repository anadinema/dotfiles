#!/bin/zsh

setopt +o nomatch

LINE=-----------------------------------------------------------------------------------------------------

install_homebrew() {
  if type brew &>/dev/null; then
    echo ""$LINE"\n ### homebrew is already installed... skipping installation... ### \n"$LINE""
  else
    echo ""$LINE"\n ### Installing homebrew... ### \n"$LINE""
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo ""$LINE"\n ### homebrew installed... ### \n"$LINE""
  fi
}

brew_apps() {
  if ! brew info bat &>/dev/null; then
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
    echo ""$LINE"\n ### Installing plugins... ### \n"$LINE""
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions || exit 1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting | exit 1
    echo ""$LINE"\n ### oh-my-zsh and related plugins installed... ### \n"$LINE""
  else
    echo ""$LINE"\n ### oh-my-zsh is already installed... skipping installation... ###\n"$LINE""
  fi
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
  cd ..
  for file in $(find $(pwd) -type f | grep stow | grep -v .config | grep -v .ssh | grep -v .m2 | sed 's/\/.dotfiles\/stow//g')
  do
    echo "$file"
    rm -r "$file" || true
  done
  for folder in $(find $(pwd) -type d | grep stow | grep -v .config | sed 's/\/.dotfiles\/stow//g')
  do
    if [[ ! $folder == $HOME ]]; then
      echo "$folder"
      rm -r "$folder" || true
    fi
  done
  rm -r $HOME/.config || true
  rm -rf "$HOME/.zshrc.pre*"
  echo ""$LINE"\n ### Folders/symlinks removed... Stowing now... ### \n"$LINE""
  stow stow
  cd "$HOME"
  sleep 4
  reload
  if ! echo "$DOTFILES" &>/dev/null; then
    echo "### Either syslink or reload failed... Exiting now.. ### \n"$LINE"" && exit 1
  else
    echo "### Stowing completed... ### \n"$LINE"" && cd "$DOTFILES/scripts"
  fi
}

perform_cleanup() {
  echo ""$LINE"\n ### Cleaning up... ### \n"$LINE""
  (rm -r .lesshst || true) && (rm -r .zcompdump* || true) && (rm -r .zsh_history* || true) &&( rm -r .zshrc.pre* || true)
  mkdir -p $DOTFILES/temp
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

set_java_version() {
  echo ""$LINE"\n ### Setting java version to 21... ### \n"$LINE""
  jvmuse 21
}

main() {
  sudo -v
  install_homebrew
  brew_apps
  install_ohmyzsh
  install_p10k
  setup_docker_plugins
  setup_dotfiles
  set_java_version
  perform_cleanup
}

main