#!/bin/zsh

install_brew() {
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_zsh_stuff() {
  echo "!!! Installing oh-my-zsh..."
  ZSH=$HOME/zshell sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc && echo "!!! oh-my-zsh installed..."
  echo "!!! Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/zshell/.oh-my-zsh/custom}/themes/powerlevel10k && echo "!!! powerlevel10k installed..."
}

brew_apps() {
  echo "!!! Installing brew bundle..."
  brew bundle install --file brew/Brewfile && echo "!!! brew bundle installed..."
  brew list
}
